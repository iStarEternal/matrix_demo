import 'dart:math';
import 'dart:ui';

import 'package:matrix_demo/x_geometry/x_geometry_utils.dart';

import '../x_quad/x_point.dart';

class XDrawBoxUtils {
  XDrawBoxUtils._();

  /// 根据四个点计算轴对齐的包围盒
  /// points = [topLeft, topRight, bottomRight, bottomLeft]
  /// 返回 [topLeft, topRight, bottomRight, bottomLeft] 四个点
  static List<Offset> getAxisAlignedBox(List<Offset> points) {
    if (points.length != 4) return [];

    final topLeft = points[0];
    final topRight = points[1];
    final bottomRight = points[2];
    final bottomLeft = points[3];

    // 上边线角度
    final angle = XGeometryUtils.angleBetweenPoints(topLeft, topRight);

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

    // 水平轴对齐的矩形边界
    final minX = [rTopLeft.dx, rBottomLeft.dx].reduce(min);
    final maxX = [rTopRight.dx, rBottomRight.dx].reduce(max);
    final minY = [rTopLeft.dy, rTopRight.dy].reduce(min);
    final maxY = [rBottomLeft.dy, rBottomRight.dy].reduce(max);

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

  /// 将四个点绕指定中心旋转指定角度
  /// angle: 弧度
  /// center: 可选旋转中心，默认使用四点中心
  static List<XPoint> rotatePoints(List<XPoint> points, double angle, {XPoint? center}) {
    if (points.isEmpty) return [];

    final cx = center?.x ?? points.map((p) => p.x).reduce((a, b) => a + b) / points.length;
    final cy = center?.y ?? points.map((p) => p.y).reduce((a, b) => a + b) / points.length;

    return points.map((p) {
      final dx = p.x - cx;
      final dy = p.y - cy;
      final rx = dx * cos(angle) - dy * sin(angle) + cx;
      final ry = dx * sin(angle) + dy * cos(angle) + cy;
      return XPoint(rx, ry);
    }).toList();
  }

  /// 根据点列表生成包围盒 Rectangle
  static Rectangle<double> getBoundingRect(List<Offset> points) {
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
