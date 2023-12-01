import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Estrutura de dados representando uma caixa delimitadora retangular pelos cantos
/// noroeste e sudeste
class LatLngBounds {
  late LatLng _sw; // Canto sudoeste
  late LatLng _ne; // Canto nordeste

  // Construtor que aceita dois cantos como argumentos
  LatLngBounds(
    LatLng corner1,
    LatLng corner2,
  ) : this.fromPoints([corner1, corner2]);

  // Construtor alternativo que cria uma caixa delimitadora a partir de uma lista de pontos
  LatLngBounds.fromPoints(List<LatLng> points)
      : assert(
          points.isNotEmpty,
          'LatLngBounds não pode ser criado com uma lista vazia de LatLng',
        ) {
    double minX = 180; // Inicializa com valor máximo possível
    double maxX = -180; // Inicializa com valor mínimo possível
    double minY = 90; // Inicializa com valor máximo possível
    double maxY = -90; // Inicializa com valor mínimo possível

    // Loop através dos pontos para encontrar os limites
    for (final point in points) {
      minX = math.min<double>(minX, point.longitude);
      minY = math.min<double>(minY, point.latitude);
      maxX = math.max<double>(maxX, point.longitude);
      maxY = math.max<double>(maxY, point.latitude);
    }

    _sw = LatLng(minY, minX); // Define o canto sudoeste
    _ne = LatLng(maxY, maxX); // Define o canto nordeste
  }

  /// Expande a caixa delimitadora para incluir um ponto [latLng]. Este método altera
  /// o objeto de limites no qual é chamado.
  void extend(LatLng latLng) {
    _extend(latLng, latLng);
  }

  /// Expande a caixa delimitadora para incluir outros limites [bounds]. Se os limites fornecidos
  /// são menores que os atuais, eles não são reduzidos. Este método altera
  /// o objeto de limites no qual é chamado.
  void extendBounds(LatLngBounds bounds) {
    _extend(bounds._sw, bounds._ne);
  }

  void _extend(LatLng sw2, LatLng ne2) {
    _sw = LatLng(
      math.min(sw2.latitude, _sw.latitude),
      math.min(sw2.longitude, _sw.longitude),
    );
    _ne = LatLng(
      math.max(ne2.latitude, _ne.latitude),
      math.max(ne2.longitude, _ne.longitude),
    );
  }

  /// Obtém a borda oeste dos limites
  double get west => southWest.longitude;

  /// Obtém a borda sul dos limites
  double get south => southWest.latitude;

  /// Obtém a borda leste dos limites
  double get east => northEast.longitude;

  /// Obtém a borda norte dos limites
  double get north => northEast.latitude;

  /// Obtém as coordenadas do canto sudoeste dos limites
  LatLng get southWest => _sw;

  /// Obtém as coordenadas do canto nordeste dos limites
  LatLng get northEast => _ne;

  /// Obtém as coordenadas do canto noroeste dos limites
  LatLng get northWest => LatLng(north, west);

  /// Obtém as coordenadas do canto sudeste dos limites
  LatLng get southEast => LatLng(south, east);

  /// Obtém as coordenadas do centro dos limites
  LatLng get center {
    /* Fórmula para encontrar o centro de um retângulo delimitador:
       https://stackoverflow.com/a/4656937
       http://www.movable-type.co.uk/scripts/latlong.html

       coord 1: southWest
       coord 2: northEast

       phi: lat
       lambda: lng
    */

    final phi1 = southWest.latitudeInRad;
    final lambda1 = southWest.longitudeInRad;
    final phi2 = northEast.latitudeInRad;

    final dLambda = degToRadian(northEast.longitude -
        southWest.longitude); // delta lambda = lambda2-lambda1

    final bx = math.cos(phi2) * math.cos(dLambda);
    final by = math.cos(phi2) * math.sin(dLambda);
    final phi3 = math.atan2(math.sin(phi1) + math.sin(phi2),
        math.sqrt((math.cos(phi1) + bx) * (math.cos(phi1) + bx) + by * by));
    final lambda3 = lambda1 + math.atan2(by, math.cos(phi1) + bx);

    // phi3 e lambda3 estão em radianos, mas LatLng quer graus
    return LatLng(radianToDeg(phi3), radianToDeg(lambda3));
  }

  /// Verifica se [point] está dentro dos limites
  bool contains(LatLng point) {
    final sw2 = point;
    final ne2 = point;
    return containsBounds(LatLngBounds(sw2, ne2));
  }

  /// Verifica se [bounds] está contido nos limites
  bool containsBounds(LatLngBounds bounds) {
    final sw2 = bounds._sw;
    final ne2 = bounds._ne;
    return (sw2.latitude >= _sw.latitude) &&
        (ne2.latitude <= _ne.latitude) &&
        (sw2.longitude >= _sw.longitude) &&
        (ne2.longitude <= _ne.longitude);
  }

  /// Verifica se pelo menos uma borda de [bounds] está sobreposta com alguma
  /// outra borda dos limites
  bool isOverlapping(LatLngBounds bounds) {
    /* Verifica se o retângulo da caixa delimitadora está fora do outro, se estiver então não está
       sobreposto
    */
    if (_sw.latitude > bounds._ne.latitude ||
        _ne.latitude < bounds._sw.latitude ||
        _ne.longitude < bounds._sw.longitude ||
        _sw.longitude > bounds._ne.longitude) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(_sw, _ne);

  @override
  bool operator ==(Object other) =>
      other is LatLngBounds && other._sw == _sw && other._ne == _ne;
}


/**Este código em Dart representa uma estrutura de dados chamada LatLngBounds que é uma caixa delimitadora retangular definida por seus cantos noroeste (NW) e sudeste (SE). Essa caixa delimitadora é usada para representar uma área geográfica no plano do mapa. Aqui estão algumas explicações:

LatLng: Isso representa um ponto no mapa usando coordenadas de latitude e longitude.

LatLngBounds: É uma caixa delimitadora que contém métodos para expansão, obtenção de bordas e verificação de interseção com outras caixas delimitadoras.

extend: Este método expande a caixa delimitadora para incluir um novo ponto ou outra caixa delimitadora.

contains: Este método verifica se um ponto está dentro da caixa delimitadora.

isOverlapping: Este método verifica se duas caixas delimitadoras têm alguma sobreposição.

center: Este método calcula o ponto central da caixa delimitadora.

hashCode e operator==: São implementados para que você possa usar as instâncias desta classe em estruturas de dados que dependem desses métodos, como Set ou Map.
**/