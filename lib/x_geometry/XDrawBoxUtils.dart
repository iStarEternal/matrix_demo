import 'dart:math';
import 'dart:ui';

import 'package:matrix_demo/x_geometry/x_geometry_utils.dart';

import '../x_quad/x_point.dart';

class XDrawBoxUtils {
  XDrawBoxUtils._();

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
