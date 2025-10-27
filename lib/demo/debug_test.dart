import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart' as vm;

import '../x_geometry/x_geometry_utils.dart';
import '../x_matrix/x_matrix_decomposition.dart';
import '../x_matrix/x_matrix_utils.dart';

/// 打印 Matrix4 的一行一行文本（返回 String）
String matrix4ToString(vm.Matrix4 m) {
  final buffer = StringBuffer();
  for (int i = 0; i < 4; i++) {
    final row = List.generate(4, (j) => m.entry(i, j).toStringAsFixed(10));
    buffer.writeln('[${row.join(', ')}]');
  }
  return buffer.toString();
}

String logText(List<Offset> A, List<Offset> B) {
  final H = XMatrixUtils.getMatrix4(A, B);

  final rotation_0_1 = XGeometryUtils.angleBetweenPointsDegree(B[0], B[1]);

  // 构建显示文本
  final matrixText = StringBuffer();

  // 原始坐标和目标坐标
  matrixText.writeln("原始四点 (A):");
  for (int i = 0; i < A.length; i++) {
    matrixText.writeln("  A[$i] = (${A[i].dx.toStringAsFixed(2)}, ${A[i].dy.toStringAsFixed(2)})");
  }
  matrixText.writeln("");

  matrixText.writeln("目标四点 (B):");
  for (int i = 0; i < B.length; i++) {
    matrixText.writeln("  B[$i] = (${B[i].dx.toStringAsFixed(2)}, ${B[i].dy.toStringAsFixed(2)})");
  }
  matrixText.writeln("");

  matrixText.writeln("矩阵 (H):");
  matrixText.writeln(matrix4ToString(H));

  final qrResult = XMatrixDecomposition.decomposeQR(H);
  final qrResultToMatrix = XMatrixDecomposition.composeFromQR(qrResult);

  matrixText.writeln("QR分解结果:");
  matrixText.writeln("  translationX = ${qrResult.translationX}");
  matrixText.writeln("  translationY = ${qrResult.translationY}");
  matrixText.writeln("  rotation_radians = ${qrResult.radians}");
  matrixText.writeln("  rotation_degree = ${qrResult.radians * 180 / pi}°");
  matrixText.writeln("  scaleX = ${qrResult.scaleX}");
  matrixText.writeln("  scaleY = ${qrResult.scaleY}");
  matrixText.writeln("  flipX = ${qrResult.flipX}");
  matrixText.writeln("  flipY = ${qrResult.flipY}");
  matrixText.writeln("  skewX = ${qrResult.skewX}");
  matrixText.writeln("  skewY = ${qrResult.skewY}");
  matrixText.writeln("");

  matrixText.writeln("QR分解结果转换回矩阵:");
  matrixText.writeln(matrix4ToString(qrResultToMatrix));

  matrixText.writeln("红→绿，0→1角度:");
  matrixText.writeln(rotation_0_1);
  matrixText.writeln("");

  // matrixText.writeln("————————————————————————————————————");
  //
  // // 获取四种分解
  // final affine = XMatrixUtils_v2.decomposeAffine(H);
  // final qr = XMatrixUtils_v2.qrDecomposition2D(H);
  // final svd = XMatrixUtils_v2.svdDecomposition2D(H);
  // final full = XMatrixUtils_v2.decomposeFull(H);
  //
  // matrixText.writeln("decomposeAffine:");
  // matrixText.writeln("  translation = ${affine['translation']}");
  // matrixText.writeln("  rotation = ${(affine['rotation'] as double) * 180 / pi}°");
  // matrixText.writeln("  scale = ${affine['scale']}");
  // matrixText.writeln("  skew = ${affine['skew']}");
  // matrixText.writeln("");
  //
  // matrixText.writeln("qrDecomposition2D:");
  // matrixText.writeln("  rotation = ${(qr['rotation'] as double) * 180 / pi}°");
  // matrixText.writeln("  scale = ${qr['scale']}");
  // matrixText.writeln("  shear = ${qr['shear']}");
  // matrixText.writeln("");
  //
  // matrixText.writeln("svdDecomposition2D:");
  // matrixText.writeln("  rotation = ${(svd['rotation'] as double) * 180 / pi}°");
  // matrixText.writeln("  scale = ${svd['scale']}");
  // matrixText.writeln("");
  //
  // matrixText.writeln("decomposeFull:");
  // matrixText.writeln("  translation = ${full['translation']}");
  // matrixText.writeln("  rotation = ${(full['rotation'] as double) * 180 / pi}°");
  // matrixText.writeln("  scale = ${full['scale']}");
  // matrixText.writeln("  skew = ${full['skew']}");
  // matrixText.writeln("  perspective = ${full['perspective']}");

  // print(matrixText.toString());

  return matrixText.toString();
}
