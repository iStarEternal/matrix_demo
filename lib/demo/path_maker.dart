import 'dart:math';
import 'dart:ui';

import 'package:matrix_demo/x_geometry/x_bounds_utils.dart';

import '../x_quad/x_quad.dart';

/// Path 工具
class PathMaker {
  /// 将点连起来
  static Path makeBoxPath(List<Offset> points) {
    if (points.isEmpty) return Path();

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  /// 五角星
  static Path makeStarPath({required Offset center, required double radius, double rotation = -pi / 2}) {
    final path = Path();
    final innerRadius = radius * 0.382; // 黄金比例，标准五角星
    final points = <Offset>[];

    for (int i = 0; i < 10; i++) {
      final angle = rotation + i * (pi / 5);
      final r = (i % 2 == 0) ? radius : innerRadius;
      points.add(center + Offset(cos(angle) * r, sin(angle) * r));
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  /// 五星红旗五颗星（按 rect 范围缩放）
  static Path makeChineseFlagStars(Rect rect) {
    final path = Path();

    // 基准：国旗比例 3:2
    final L = rect.width;
    final W = rect.height;

    // 大星
    final bigCenter = Offset(rect.left + 0.15 * L, rect.top + 0.3 * W);
    final bigRadius = 0.06 * L;
    path.addPath(makeStarPath(center: bigCenter, radius: bigRadius), Offset.zero);

    // 小星公共半径
    final smallRadius = 0.02 * L;

    // 小星坐标（相对左上角）
    final smallCenters = [
      Offset(0.25 * L, 0.15 * W),
      Offset(0.30 * L, 0.25 * W),
      Offset(0.30 * L, 0.40 * W),
      Offset(0.25 * L, 0.50 * W),
    ].map((o) => Offset(rect.left + o.dx, rect.top + o.dy)).toList();

    // 每颗小星的旋转方向：指向大星
    for (final c in smallCenters) {
      final dx = bigCenter.dx - c.dx;
      final dy = bigCenter.dy - c.dy;
      final angle = atan2(dy, dx); // 小星一个角朝向大星
      path.addPath(makeStarPath(center: c, radius: smallRadius, rotation: angle), Offset.zero);
    }

    return path;
  }

  /// 使用 XBoundsUtils 计算包围盒并转 Path
  static Path makeBoundingBox_obb01(XQuad quad) {
    final boxQuad = XBoundsUtils.getAxisAlignedBox(quad);
    final boxPoints = boxQuad.toOffsets();
    return makeBoxPath(boxPoints);
  }

  /// 使用 XBoundsUtils 计算包围盒并转 Path
  static Path makeBoundingBox_aabb(XQuad quad) {
    final outerRect = quad.toOuterRect();
    final outerQuad = XQuad.fromRect(outerRect);
    return makeBoxPath(outerQuad.toOffsets());
  }
}
