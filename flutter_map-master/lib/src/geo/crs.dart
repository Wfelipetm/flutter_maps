import 'dart:math' as math hide Point;
import 'dart:math' show Point;

import 'package:flutter_map/src/misc/bounds.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

/// Uma representação abstrata de um
/// [Coordinate Reference System](https://bit.ly/3iVKpja).
///
/// O objetivo principal de um CRS é lidar com a conversão entre superfície
/// pontos de objetos de diferentes dimensões. No nosso caso, objetos 3D e 2D.

// Classe abstrata representando um Sistema de Referência de Coordenadas (CRS)
@immutable
abstract class Crs {
  const Crs();

  String get code; // Identificador único do CRS

  Projection get projection; // Projeção usada para converter lat/lng para pontos de mapa

  Transformation get transformation; // Transformação usada para escalar e desescalar pontos

  // Converte uma coordenada lat/lng em um ponto no mapa
  Point<double> latLngToPoint(LatLng latlng, double zoom) {
    final projectedPoint = projection.project(latlng);
    return transformation.transform(projectedPoint, scale(zoom));
  }

  // Converte um ponto no mapa de volta para coordenada lat/lng
  LatLng pointToLatLng(Point point, double zoom) =>
      projection.unproject(transformation.untransform(point, scale(zoom)));

  // Função para calcular a escala com base no zoom
  double scale(double zoom) => 256.0 * math.pow(2, zoom);

  // Função para calcular o zoom com base na escala
  double zoom(double scale) => math.log(scale / 256) / math.ln2;

  // Obtém os limites projetados para um determinado nível de zoom
  Bounds<double>? getProjectedBounds(double zoom) {
    if (infinite) return null;

    final b = projection.bounds!;
    final s = scale(zoom);
    final min = transformation.transform(b.min, s);
    final max = transformation.transform(b.max, s);
    return Bounds<double>(min, max);
  }

   bool get infinite; // Indica se o CRS é infinito (sem limites)

  (double, double)? get wrapLng; // Limites de envolvimento de longitude (se houver)

  (double, double)? get wrapLat; // Limites de envolvimento de latitude (se houver)
}

// Classe abstrata representando a Terra como um CRS
@immutable
class CrsSimple extends Crs {
  @override
  final String code = 'CRS.SIMPLE';

  @override
  final Projection projection;

  @override
  final Transformation transformation;

  const CrsSimple()
      : projection = const _LonLat(),
        transformation = const Transformation(1, 0, -1, 0),
        super();

  @override
  bool get infinite => false;

  @override
  (double, double)? get wrapLat => null;

  @override
  (double, double)? get wrapLng => null;
}

@immutable
abstract class Earth extends Crs {
  @override
  bool get infinite => false;

  @override
  final (double, double) wrapLng = const (-180, 180);

  @override
  final (double, double)? wrapLat = null;

  const Earth() : super();
}

// CRS mais comum usado para renderizar mapas
@immutable
class Epsg3857 extends Earth {
  @override
  final String code = 'EPSG:3857';

  @override
  final Projection projection;

  @override
  final Transformation transformation;

  static const double _scale = 0.5 / (math.pi * SphericalMercator.r);

  const Epsg3857()
      : projection = const SphericalMercator(),
        transformation = const Transformation(_scale, 0.5, -_scale, 0.5),
        super();

// Epsg3857 seems to have latitude limits. https://epsg.io/3857
//@override
//(double, double) get wrapLat => const (-85.06, 85.06);
}

// CRS comum entre entusiastas de GIS, usa projeção Equirectangular simples
@immutable
class Epsg4326 extends Earth {
  @override
  final String code = 'EPSG:4326';

  @override
  final Projection projection;

  @override
  final Transformation transformation;

  const Epsg4326()
      : projection = const _LonLat(),
        transformation = const Transformation(1 / 180, 1, -1 / 180, 0.5),
        super();
}

// CRS personalizado usando a biblioteca Proj4
@immutable
class Proj4Crs extends Crs {
  @override
  final String code;

  @override
  final Projection projection;

  @override
  final Transformation transformation;

  @override
  final bool infinite;

  @override
  final (double, double)? wrapLat = null;

  @override
  final (double, double)? wrapLng = null;

  final List<Transformation>? _transformations;

  final List<double> _scales;

  const Proj4Crs._({
    required this.code,
    required this.projection,
    required this.transformation,
    required this.infinite,
    List<Transformation>? transformations,
    required List<double> scales,
  })  : _transformations = transformations,
        _scales = scales;

  // Fábrica para criar um Proj4Crs a partir de parâmetros fornecidos
  factory Proj4Crs.fromFactory({
    required String code,
    required proj4.Projection proj4Projection,
    Transformation? transformation,
    List<Point<double>>? origins,
    Bounds<double>? bounds,
    List<double>? scales,
    List<double>? resolutions,
  }) {
    final projection =
        _Proj4Projection(proj4Projection: proj4Projection, bounds: bounds);
    List<Transformation>? transformations;
    final infinite = null == bounds;
    List<double> finalScales;

    if (null != scales && scales.isNotEmpty) {
      finalScales = scales;
    } else if (null != resolutions && resolutions.isNotEmpty) {
      finalScales = resolutions.map((r) => 1 / r).toList(growable: false);
    } else {
      throw Exception(
          'Please provide scales or resolutions to determine scales');
    }

    if (null == origins || origins.isEmpty) {
      transformation ??= const Transformation(1, 0, -1, 0);
    } else {
      if (origins.length == 1) {
        final origin = origins[0];
        transformation = Transformation(1, -origin.x, -1, origin.y);
      } else {
        transformations =
            origins.map((p) => Transformation(1, -p.x, -1, p.y)).toList();
        transformation = null;
      }
    }

    return Proj4Crs._(
      code: code,
      projection: projection,
      transformation: transformation!,
      infinite: infinite,
      transformations: transformations,
      scales: finalScales,
    );
  }

   // Converte um ponto na superfície da esfera (com um certo zoom) em um ponto do mapa
  @override
  Point<double> latLngToPoint(LatLng latlng, double zoom) {
    final projectedPoint = projection.project(latlng);
    final scale = this.scale(zoom);
    final transformation = _getTransformationByZoom(zoom);

    return transformation.transform(projectedPoint, scale);
  }

  // Converte um ponto do mapa na coordenada da esfera (com um determinado zoom)
  @override
  LatLng pointToLatLng(Point point, double zoom) => projection.unproject(
      _getTransformationByZoom(zoom).untransform(point, scale(zoom)));

  // Redimensiona os limites para um determinado valor de zoom
  @override
  Bounds<double>? getProjectedBounds(double zoom) {
    if (infinite) return null;

    final b = projection.bounds!;
    final s = scale(zoom);

    final transformation = _getTransformationByZoom(zoom);

    final min = transformation.transform(b.min, s);
    final max = transformation.transform(b.max, s);
    return Bounds<double>(min, max);
  }

  // Função para converter zoom em escala
  @override
  double scale(double zoom) {
    final iZoom = zoom.floor();
    if (zoom == iZoom) {
      return _scales[iZoom];
    } else {
      // Non-integer zoom, interpolate
      final baseScale = _scales[iZoom];
      final nextScale = _scales[iZoom + 1];
      final scaleDiff = nextScale - baseScale;
      final zDiff = zoom - iZoom;
      return baseScale + scaleDiff * zDiff;
    }
  }

  // Função para converter escala em zoom
  @override
  double zoom(double scale) {
    // Encontra o número mais próximo em _scales, para baixo
    final downScale = _closestElement(_scales, scale);
    if (downScale == null) {
      return double.negativeInfinity;
    }
    final downZoom = _scales.indexOf(downScale);
    // Verifica se a escala é downScale => retorna o índice do array
    if (scale == downScale) {
      return downZoom.toDouble();
    }
    // Interpola
    final nextZoom = downZoom + 1;
    final nextScale = _scales[nextZoom];

    final scaleDiff = nextScale - downScale;
    return (scale - downScale) / scaleDiff + downZoom;
  }

  /// Função para encontrar o elemento mais próximo e menor em uma lista
double? _closestElement(List<double> array, double element) {
  double? low;

  // Itera sobre a lista de trás para frente
  for (var i = array.length - 1; i >= 0; i--) {
    final curr = array[i];

    // Verifica se o elemento na lista é menor ou igual ao elemento desejado
    // e se ainda não foi atribuído um valor menor
    if (curr <= element && (null == low || low < curr)) {
      low = curr;
    }
  }

  // Retorna o elemento mais próximo e menor
  return low;
}

  /// Retorna um objeto de Transformação com base no nível de zoom
  Transformation _getTransformationByZoom(double zoom) {
    final transformations = _transformations;

    // Verifica se há transformações disponíveis e se não estiver vazio
    if (transformations == null || transformations.isEmpty) {
      return transformation;
    }

    final iZoom = zoom.round();
    final lastIdx = transformations.length - 1;

    // Retorna a transformação correspondente ao nível de zoom
    return transformations[iZoom > lastIdx ? lastIdx : iZoom];
  }
}

@immutable
abstract class Projection {
  const Projection();

  // Retorna os limites da projeção
  Bounds<double>? get bounds;

  // Converte coordenadas geográficas para coordenadas no plano do mapa
  Point<double> project(LatLng latlng);

  // Converte coordenadas no plano do mapa para coordenadas geográficas
  LatLng unproject(Point point);

  // Função interna para garantir que um valor esteja dentro de um intervalo
  double _inclusive(double start, double end, double value) {
    if (value < start) return start;
    if (value > end) return end;

    return value;
  }

  // Função para garantir que a latitude esteja dentro do intervalo -90 a 90 graus
  @protected
  double inclusiveLat(double value) {
    return _inclusive(-90, 90, value);
  }

  // Função para garantir que a longitude esteja dentro do intervalo -180 a 180 graus
  @protected
  double inclusiveLng(double value) {
    return _inclusive(-180, 180, value);
  }
}

// Implementação de Projection para coordenadas de longitude e latitude
class _LonLat extends Projection {
  // Limites para longitude e latitude
  static final Bounds<double> _bounds = Bounds<double>(
      const Point<double>(-180, -90), const Point<double>(180, 90));

  const _LonLat() : super();

  @override
  Bounds<double> get bounds => _bounds;

  // Converte coordenadas de latitude e longitude para coordenadas do plano do mapa
  @override
  Point<double> project(LatLng latlng) {
    return Point(latlng.longitude, latlng.latitude);
  }

  // Converte coordenadas do plano do mapa para coordenadas de latitude e longitude
  @override
  LatLng unproject(Point point) {
    return LatLng(
        inclusiveLat(point.y.toDouble()), inclusiveLng(point.x.toDouble()));
  }
}

// Implementação de Projection para a projeção mercator esférica
@immutable
class SphericalMercator extends Projection {
  // Raio da esfera utilizada na projeção
  static const int r = 6378137;
  // Latitude máxima suportada pela projeção
  static const double maxLatitude = 85.0511287798;
  // Limites para coordenadas projetadas
  static const double _boundsD = r * math.pi;
  static final Bounds<double> _bounds = Bounds<double>(
    const Point<double>(-_boundsD, -_boundsD),
    const Point<double>(_boundsD, _boundsD),
  );

  const SphericalMercator() : super();

  @override
  Bounds<double> get bounds => _bounds;

  // Converte coordenadas de latitude e longitude para coordenadas do plano do mapa
  @override
  Point<double> project(LatLng latlng) {
    const d = math.pi / 180;
    final lat = latlng.latitude.clamp(-maxLatitude, maxLatitude);
    final sin = math.sin(lat * d);

    return Point(
      r * d * latlng.longitude,
      r / 2 * math.log((1 + sin) / (1 - sin)),
    );
  }

  // Converte coordenadas do plano do mapa para coordenadas de latitude e longitude
  @override
  LatLng unproject(Point point) {
    const d = 180 / math.pi;
    return LatLng(
        inclusiveLat(
            (2 * math.atan(math.exp(point.y / r)) - (math.pi / 2)) * d),
        inclusiveLng(point.x * d / r));
  }
}

// Implementação de Projection utilizando a biblioteca Proj4Dart
@immutable
class _Proj4Projection extends Projection {
  // Projeção WGS84 para referência
  final proj4.Projection epsg4326;
  // Projeção personalizada
  final proj4.Projection proj4Projection;

  @override
  final Bounds<double>? bounds;

  _Proj4Projection({
    required this.proj4Projection,
    this.bounds,
  }) : epsg4326 = proj4.Projection.WGS84;

  // Converte coordenadas de latitude e longitude para coordenadas do plano do mapa
  @override
  Point<double> project(LatLng latlng) {
    final point = epsg4326.transform(
        proj4Projection, proj4.Point(x: latlng.longitude, y: latlng.latitude));

    return Point(point.x, point.y);
  }

  // Converte coordenadas do plano do mapa para coordenadas de latitude e longitude
  @override
  LatLng unproject(Point point) {
    final point2 = proj4Projection.transform(
        epsg4326, proj4.Point(x: point.x.toDouble(), y: point.y.toDouble()));

    return LatLng(inclusiveLat(point2.y), inclusiveLng(point2.x));
  }
}

// Implementação de uma transformação linear
@immutable
class Transformation {
  final double a;
  final double b;
  final double c;
  final double d;

  const Transformation(this.a, this.b, this.c, this.d);

  // Aplica a transformação a um ponto com uma escala opcional
  Point<double> transform(Point point, double? scale) {
    scale ??= 1.0;
    final x = scale * (a * point.x + b);
    final y = scale * (c * point.y + d);
    return Point(x, y);
  }

  // Desfaz a transformação aplicada a um ponto com uma escala opcional
  Point<double> untransform(Point point, double? scale) {
    scale ??= 1.0;
    final x = (point.x / scale - b) / a;
    final y = (point.y / scale - d) / c;
    return Point(x, y);
  }
}