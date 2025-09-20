import 'dart:math';
import 'dart:ui';

class XRotationUtils {
  XRotationUtils._();

  /// 将弧度 (radian) 转换为角度 (degree)
  /// 例如：弧度 π/2 转换为 90 度
  static double radianToDegree(double radian) {
    return radian * 180 / pi;
  }

  /// 将角度 (degree) 转换为弧度 (radian)
  /// 例如：90 度 转换为 π/2 弧度
  static double degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  /// 获取 AB 的角度
  static double getRotationDegree(Offset pointA, Offset pointB) {
    final dx = pointB.dx - pointA.dx;
    final dy = pointB.dy - pointA.dy;
    final radians = atan2(dy, dx);
    return radians * 180 / pi; // 转为度数
  }

  static double getRotation(Offset pointA, Offset pointB) {
    final dx = pointB.dx - pointA.dx;
    final dy = pointB.dy - pointA.dy;
    return atan2(dy, dx); // 弧度
  }
}

class XDrawBoxUtils {
  XDrawBoxUtils._();

  /// 获取一个包围盒子，points = [topLeft, topRight, bottomRight, bottomLeft]
  static List<Offset> getPointsDrawBox(List<Offset> points) {
    if (points.length != 4) return [];

    final topLeft = points[0];
    final topRight = points[1];
    final bottomRight = points[2];
    final bottomLeft = points[3];

    // 上边角度
    final angle = XRotationUtils.getRotation(topLeft, topRight);

    final cosA = cos(-angle);
    final sinA = sin(-angle);

    // 将点绕 topLeft 旋转到水平
    Offset rotateToHorizontal(Offset p) {
      final dx = p.dx - topLeft.dx;
      final dy = p.dy - topLeft.dy;
      return Offset(dx * cosA - dy * sinA, dx * sinA + dy * cosA);
    }

    final rTopLeft = rotateToHorizontal(topLeft);
    final rTopRight = rotateToHorizontal(topRight);
    final rBottomRight = rotateToHorizontal(bottomRight);
    final rBottomLeft = rotateToHorizontal(bottomLeft);

    // 水平轴对齐的矩形
    final minX = [rTopLeft.dx, rBottomLeft.dx].reduce((a, b) => a < b ? a : b);
    final maxX = [rTopRight.dx, rBottomRight.dx].reduce((a, b) => a > b ? a : b);
    final minY = [rTopLeft.dy, rTopRight.dy].reduce((a, b) => a < b ? a : b);
    final maxY = [rBottomLeft.dy, rBottomRight.dy].reduce((a, b) => a > b ? a : b);

    // 旋转回原角度
    final cosB = cos(angle);
    final sinB = sin(angle);

    Offset rotateBack(double x, double y) {
      final px = x * cosB - y * sinB + topLeft.dx;
      final py = x * sinB + y * cosB + topLeft.dy;
      return Offset(px, py);
    }

    return [
      rotateBack(minX, minY), // topLeft
      rotateBack(maxX, minY), // topRight
      rotateBack(maxX, maxY), // bottomRight
      rotateBack(minX, maxY), // bottomLeft
    ];
  }

  /// 传入4个点和旋转角度(弧度)，返回旋转后的4个点
  static List<Offset> getRotatedPoints(List<Offset> points, double angle, {Offset? center}) {
    if (points.length != 4) return [];

    // 计算旋转中心，如果没有传入，则取四点中心
    final cx = center?.dx ?? points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    final cy = center?.dy ?? points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;

    final rotatedPoints = points.map((p) {
      final dx = p.dx - cx;
      final dy = p.dy - cy;
      final rx = dx * cos(angle) - dy * sin(angle) + cx;
      final ry = dx * sin(angle) + dy * cos(angle) + cy;
      return Offset(rx, ry);
    }).toList();

    return rotatedPoints;
  }

  Rectangle<double> getRectDrawBox(List<Offset> points) {
    if (points.isEmpty) return Rectangle(0, 0, 0, 0);

    double minX = points[0].dx;
    double maxX = points[0].dx;
    double minY = points[0].dy;
    double maxY = points[0].dy;

    for (var p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }

    return Rectangle(minX, minY, maxX - minX, maxY - minY);
  }
}
