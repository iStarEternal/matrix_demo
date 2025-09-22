import 'package:flutter/material.dart';
import 'package:matrix_demo/demo/path_maker.dart';
import 'package:matrix_demo/x_matrix/x_matrix_utils.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

class AffinePainter extends CustomPainter {
  final XQuad quadA;
  final XQuad quadB;
  final List<Color> colors;

  AffinePainter({required this.quadA, required this.quadB, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final offsetsA = quadA.toOffsets();
    final offsetsB = quadB.toOffsets();

    // 1. 绘制 A 点
    _drawQuadPoints(canvas, offsetsA, colors);

    // 2. 绘制 A 的矩形和五角星
    final pathA = _makeQuadPath(offsetsA, quadA);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.withAlpha(80)
      ..isAntiAlias = true;
    canvas.drawPath(pathA, paint);

    // 3. 绘制 B 点
    _drawQuadPoints(canvas, offsetsB, colors);

    // 4. 透视变换并绘制 B 的路径
    _drawTransformedPath(canvas, pathA, offsetsA, offsetsB);

    // 5. 绘制 B 的 0 → 1 包围盒
    _drawOBB01BoundingBox(canvas, quadB);
    _drawAABBBoundingBox(canvas, quadB);
  }

  /// 绘制 Quad 的 4 个点
  void _drawQuadPoints(Canvas canvas, List<Offset> offsets, List<Color> colors) {
    final fillPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < offsets.length; i++) {
      fillPaint.color = colors[i].withOpacity(0.3);
      canvas.drawCircle(offsets[i], 6, fillPaint);
    }
  }

  /// 生成 Quad 的矩形 + 五角星 Path
  Path _makeQuadPath(List<Offset> offsets, XQuad quad) {
    final path = Path();

    // 1. 外框矩形
    final rect = quad.outerRect();
    path.addRect(rect);

    // 2. 五星红旗里的五颗星
    final flagStars = PathMaker.makeChineseFlagStars(rect);
    path.addPath(flagStars, Offset.zero);

    return path;
  }

  /// 透视变换并绘制 Path
  void _drawTransformedPath(Canvas canvas, Path pathA, List<Offset> a, List<Offset> b) {
    final matrix = XMatrixUtils.getMatrix4(a, b);
    final pathB = pathA.transform(matrix.storage);

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;
    canvas.drawPath(pathB, paint);
  }

  /// 绘制 B 的 0 → 1 包围盒
  void _drawOBB01BoundingBox(Canvas canvas, XQuad quad) {
    final bBoxPath = PathMaker.makeBoundingBox_obb01(quad);
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawPath(bBoxPath, paint);
  }


  /// 绘制 B 的 AABB 包围盒
  void _drawAABBBoundingBox(Canvas canvas, XQuad quad) {
    final bBoxPath = PathMaker.makeBoundingBox_aabb(quad);
    final paint = Paint()
      ..color = Colors.lightBlue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawPath(bBoxPath, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
