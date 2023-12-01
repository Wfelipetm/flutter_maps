// Importações necessárias
import 'dart:math';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';

// Constante para converter radianos para graus
const double piOver180 = pi / 180.0;

// Função para converter radianos para graus
double toDegrees(double radians) {
  return radians / piOver180;
}

// Função para converter graus para radianos
double toRadians(double degrees) {
  return degrees * piOver180;
}

// Função para calcular as coordenadas finais globais
LatLng calculateEndingGlobalCoordinates(
    LatLng start, double startBearing, double distance) {
  // Constantes relacionadas ao elipsoide WGS84
  const mSemiMajorAxis = 6378137.0; // Eixo principal do WGS84
  const mSemiMinorAxis = (1.0 - 1.0 / 298.257223563) * 6378137.0;
  const mFlattening = 1.0 / 298.257223563;

  // Parâmetros do elipsoide
  const a = mSemiMajorAxis;
  const b = mSemiMinorAxis;
  const aSquared = a * a;
  const bSquared = b * b;
  const f = mFlattening;

  // Conversão das coordenadas iniciais para radianos
  final phi1 = toRadians(start.latitude);
  final alpha1 = toRadians(startBearing);
  final cosAlpha1 = cos(alpha1);
  final sinAlpha1 = sin(alpha1);
  final s = distance;
  final tanU1 = (1.0 - f) * tan(phi1);
  final cosU1 = 1.0 / sqrt(1.0 + tanU1 * tanU1);
  final sinU1 = tanU1 * cosU1;

  // Equações iniciais
  final sigma1 = atan2(tanU1, cosAlpha1);
  final sinAlpha = cosU1 * sinAlpha1;
  final sin2Alpha = sinAlpha * sinAlpha;
  final cos2Alpha = 1 - sin2Alpha;
  final uSquared = cos2Alpha * (aSquared - bSquared) / bSquared;

  // Equações intermediárias
  final A = 1 +
      (uSquared / 16384) *
          (4096 + uSquared * (-768 + uSquared * (320 - 175 * uSquared)));
  final B = (uSquared / 1024) *
      (256 + uSquared * (-128 + uSquared * (74 - 47 * uSquared)));

  // Iteração para encontrar a mudança negligenciável em sigma
  double deltaSigma;
  final sOverbA = s / (b * A);
  var sigma = sOverbA;
  double sinSigma;
  var prevSigma = sOverbA;
  double sigmaM2;
  double cosSigmaM2;
  double cos2SigmaM2;

  while (true) {
    sigmaM2 = 2.0 * sigma1 + sigma;
    cosSigmaM2 = cos(sigmaM2);
    cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;
    sinSigma = sin(sigma);
    final cosSignma = cos(sigma);

    // Equações para iteração
    deltaSigma = B *
        sinSigma *
        (cosSigmaM2 +
            (B / 4.0) *
                (cosSignma * (-1 + 2 * cos2SigmaM2) -
                    (B / 6.0) *
                        cosSigmaM2 *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM2)));

    sigma = sOverbA + deltaSigma;

    // Quebrar o loop quando convergir para a tolerância
    if ((sigma - prevSigma).abs() < 0.0000000000001) break;

    prevSigma = sigma;
  }

  sigmaM2 = 2.0 * sigma1 + sigma;
  cosSigmaM2 = cos(sigmaM2);
  cos2SigmaM2 = cosSigmaM2 * cosSigmaM2;

  final cosSigma = cos(sigma);
  sinSigma = sin(sigma);

  // Equações finais para calcular as coordenadas finais
  final phi2 = atan2(
      sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
      (1.0 - f) *
          sqrt(sin2Alpha +
              pow(sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1, 2.0)));

  // Correção para problemas perto dos polos
  final lambda = atan2(
    sinSigma * sinAlpha1,
    cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1,
  );

  // Mais equações finais
  final C = (f / 16) * cos2Alpha * (4 + f * (4 - 3 * cos2Alpha));
  final L = lambda -
      (1 - C) *
          f *
          sinAlpha *
          (sigma +
              C *
                  sinSigma *
                  (cosSigmaM2 + C * cosSigma * (-1 + 2 * cos2SigmaM2)));

  // Equações para construir o resultado final
  return LatLng(
    clampDouble(toDegrees(phi2), -90, 90),
    clampDouble(start.longitude + toDegrees(L), -180, 180),
  );
}

// Função de utilidade para limitar um valor dentro de um intervalo específico
double clampDouble(double value, double min, double max) {
  assert(min <= max);
  if (value < min) return min;
  if (value > max) return max;
  return value;
}
/**

Conversões entre Graus e Radianos:

piOver180: Constante usada para converter graus em radianos.
toDegrees e toRadians: Funções para converter entre graus e radianos.
Função Principal (calculateEndingGlobalCoordinates):

LatLng start: Coordenadas iniciais.
double startBearing: Ângulo inicial em radianos.
double distance: Distância a percorrer.
Constantes Relacionadas ao Elipsoide WGS84:

mSemiMajorAxis: Eixo maior do elipsoide.
mSemiMinorAxis: Eixo menor do elipsoide.
mFlattening: Achatamento do elipsoide.
Parâmetros do Elipsoide e Coordenadas Iniciais:

a, b, aSquared, bSquared, f: Parâmetros do elipsoide WGS84.
phi1, alpha1, cosAlpha1, sinAlpha1: Coordenadas iniciais e cálculos relacionados.
Algoritmo Vincenty para Cálculos Geodésicos:

O código inclui uma implementação do algoritmo Vincenty, um método iterativo para cálculos geodésicos mais precisos.
Resultado Final e Limitação de Valores:

LatLng(...) e clampDouble(...): Resultado final convertido de radianos para graus e função de utilidade para limitar os valores dentro de intervalos específicos.



 */