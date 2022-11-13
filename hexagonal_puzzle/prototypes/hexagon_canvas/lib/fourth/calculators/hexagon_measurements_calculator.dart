import 'dart:math' as math;

/// Calculate measurements of a hexagon
/// The measurements consist of three values:
/// [a] the long leg of a triangle in which the side of the hexagon is the hypotenuse
/// [b] the short leg of a triangle in which the side of the hexagon is the hypotenuse
/// [c] side length of the hexagon (a hypotenuse of the triangle)
class HexagonMeasurementsCalculator {
  HexagonMeasurementsCalculator(this.a) {
    const alphaAngle = math.pi / 3;   // 60 degrees

    b = (a / math.tan(alphaAngle)).roundToDouble();
    c = (a / math.sin(alphaAngle)).roundToDouble();
  }

  late final double a;
  late final double b;
  late final double c;

  double get width {
    return a * 2;
  }

  double get height {
    return b * 2 + c;
  }
}