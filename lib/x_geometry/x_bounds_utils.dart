import 'dart:math';
import 'dart:ui';

import 'package:matrix_demo/x_geometry/x_geometry_utils.dart';

import '../x_quad/x_point.dart';
import '../x_quad/x_quad.dart';

/// 包围盒子
class XBoundsUtils {
  /// 根据四边形计算的包围盒
  ///   - 以上边线为基准计算的
  static XQuad getAxisAlignedBox(XQuad quad) {
    final topLeft = quad.topLeft.toOffset();
    final topRight = quad.topRight.toOffset();
    final bottomRight = quad.bottomRight.toOffset();
    final bottomLeft = quad.bottomLeft.toOffset();

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

    return XQuad(
      topLeft: rotateBack(minX, minY).toPoint(),
      topRight: rotateBack(maxX, minY).toPoint(),
      bottomRight: rotateBack(maxX, maxY).toPoint(),
      bottomLeft: rotateBack(minX, maxY).toPoint(), //
    );
  }

  /// 计算最小的轴对齐矩形盒子 (AABB)
  static Rect getBoundingRect(XQuad points) {
    final xs = [points.topLeft.x, points.topRight.x, points.bottomLeft.x, points.bottomRight.x];
    final ys = [points.topLeft.y, points.topRight.y, points.bottomLeft.y, points.bottomRight.y];

    final minX = xs.reduce(min);
    final maxX = xs.reduce(max);
    final minY = ys.reduce(min);
    final maxY = ys.reduce(max);

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}

class XBoundsUtils_Points {
  /// 计算最小外接矩形 (OBB, Oriented Bounding Box)
  static XQuad getMinimalBoundingBox(List<XPoint> inputPoints) {
    if (inputPoints.length < 3) {
      throw ArgumentError("至少需要 3 个点");
    }

    // 1. 计算凸包
    final hull = _convexHull(inputPoints);
    if (hull.length < 3) {
      throw ArgumentError("凸包不足 3 个点");
    }

    double minArea = double.infinity;
    XQuad? bestQuad;

    // 2. 遍历凸包的每条边
    for (int i = 0; i < hull.length; i++) {
      final p1 = hull[i];
      final p2 = hull[(i + 1) % hull.length];

      final edgeAngle = atan2(p2.y - p1.y, p2.x - p1.x);

      final cosA = cos(-edgeAngle);
      final sinA = sin(-edgeAngle);

      // 旋转点到水平
      List<XPoint> rotated = hull.map((p) {
        final dx = p.x - p1.x;
        final dy = p.y - p1.y;
        return XPoint(dx * cosA - dy * sinA, dx * sinA + dy * cosA);
      }).toList();

      // 求 AABB
      final minX = rotated.map((p) => p.x).reduce(min);
      final maxX = rotated.map((p) => p.x).reduce(max);
      final minY = rotated.map((p) => p.y).reduce(min);
      final maxY = rotated.map((p) => p.y).reduce(max);

      final area = (maxX - minX) * (maxY - minY);

      if (area < minArea) {
        minArea = area;

        // 旋转回去
        final cosB = cos(edgeAngle);
        final sinB = sin(edgeAngle);

        XPoint rotateBack(double x, double y) {
          final px = x * cosB - y * sinB + p1.x;
          final py = x * sinB + y * cosB + p1.y;
          return XPoint(px, py);
        }

        bestQuad = XQuad(
          topLeft: rotateBack(minX, minY),
          topRight: rotateBack(maxX, minY),
          bottomRight: rotateBack(maxX, maxY),
          bottomLeft: rotateBack(minX, maxY),
        );
      }
    }

    return bestQuad!;
  }

  /// ===================
  /// 凸包算法 (Graham Scan)
  /// ===================
  static List<XPoint> _convexHull(List<XPoint> points) {
    final pts = [...points];
    pts.sort((a, b) => a.x == b.x ? a.y.compareTo(b.y) : a.x.compareTo(b.x));

    List<XPoint> lower = [];
    for (var p in pts) {
      while (lower.length >= 2 && _cross(lower[lower.length - 2], lower.last, p) <= 0) {
        lower.removeLast();
      }
      lower.add(p);
    }

    List<XPoint> upper = [];
    for (var p in pts.reversed) {
      while (upper.length >= 2 && _cross(upper[upper.length - 2], upper.last, p) <= 0) {
        upper.removeLast();
      }
      upper.add(p);
    }

    lower.removeLast();
    upper.removeLast();
    return [...lower, ...upper];
  }

  static double _cross(XPoint o, XPoint a, XPoint b) {
    return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
  }
}
