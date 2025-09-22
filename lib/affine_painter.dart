import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrix_demo/x_geometry/XDrawBoxUtils.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

import 'x_matrix/x_matrix_utils.dart';

class AffinePainter extends CustomPainter {
  final XQuad quadA;
  final XQuad quadB;
  final List<Color> colors;

  AffinePainter({required this.quadA, required this.quadB, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    // 缓存 Offset 列表，避免重复调用 toPoints().toOffset()
    final A = quadA.toOffsets();
    final B = quadB.toOffsets();

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.withAlpha(80);

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // 画 A 点
    for (int i = 0; i < A.length; i++) {
      fillPaint.color = colors[i].withOpacity(0.3);
      canvas.drawCircle(A[i], 6, fillPaint);
    }

    // 画 A 矩形
    final pathA = Path()..moveTo(A[0].dx, A[0].dy);
    for (int i = 1; i < A.length; i++) {
      pathA.lineTo(A[i].dx, A[i].dy);
    }
    pathA.close();

    // 画五角星
    final starPath = _makeStarPath(center: quadA.getCenter().toOffset(), radius: 40);
    pathA.addPath(starPath, Offset.zero);

    paint
      ..color = Colors.grey.withAlpha(80)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pathA, paint..isAntiAlias = true);

    // 画 B 点
    for (int i = 0; i < B.length; i++) {
      fillPaint.color = colors[i].withOpacity(0.3);
      canvas.drawCircle(B[i], 6, fillPaint);
    }

    // 计算透视矩阵
    final matrix = XMatrixUtils.getMatrix4(A, B);
    final pathB = pathA.transform(matrix.storage);

    // 画 B 变换后的路径
    paint
      ..color = Colors.black
      ..strokeWidth = 1;
    canvas.drawPath(pathB, paint);

    // 画 B 的包围盒
    final bBoxPath = _makeBDrawBox(B);
    paint
      ..color = Colors.purple
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(bBoxPath, paint);
  }

  /// 画五角星
  Path _makeStarPath({required Offset center, required double radius}) {
    final path = Path();
    final innerRadius = radius * 0.5;
    final points = <Offset>[];
    for (int i = 0; i < 10; i++) {
      final angle = i * (pi / 5) - pi / 2;
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

  /// B 点包围盒路径
  Path _makeBDrawBox(List<Offset> points) {
    final boxPoints = XDrawBoxUtils.getAxisAlignedBox(points);

    if (boxPoints.isEmpty) return Path();

    final path = Path();
    path.moveTo(boxPoints[0].dx, boxPoints[0].dy); // topLeft
    path.lineTo(boxPoints[1].dx, boxPoints[1].dy); // topRight
    path.lineTo(boxPoints[2].dx, boxPoints[2].dy); // bottomRight
    path.lineTo(boxPoints[3].dx, boxPoints[3].dy); // bottomLeft
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
