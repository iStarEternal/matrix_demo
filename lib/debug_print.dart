import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart' as vm;

import 'Geee.dart';
import 'XMatrixUtils2D.dart';
import 'matrix_utils.dart';

void printAllDecompose(vm.Matrix4 H) {
  final affine = XMatrixUtils.decomposeAffine(H);
  final qr = XMatrixUtils.qrDecomposition2D(H);
  final svd = XMatrixUtils.svdDecomposition2D(H);
  final full = XMatrixUtils.decomposeFull(H);

  print('===== 分解结果 =====');

  print('decomposeAffine:');
  print('  rotation = ${(affine['rotation'] as double) * 180 / pi}°');
  print('  translation = ${affine['translation']}');
  print('  scale = ${affine['scale']}');
  print('  skew = ${affine['skew']}');

  print('qrDecomposition2D:');
  print('  rotation = ${(qr['rotation'] as double) * 180 / pi}°');
  print('  scale = ${qr['scale']}');
  print('  shear = ${qr['shear']}');

  print('svdDecomposition2D:');
  print('  rotation = ${(svd['rotation'] as double) * 180 / pi}°');
  print('  scale = ${svd['scale']}');

  print('decomposeFull:');
  print('  rotation = ${(full['rotation'] as double) * 180 / pi}°');
  print('  scale = ${full['scale']}');
  print('  skew = ${full['skew']}');
  print('  translation = ${full['translation']}');
  print('  perspective = ${full['perspective']}');

  print('====================');
}

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

  final rotation_0_1 = XRotationUtils.getRotationDegree(B[0], B[1]);

  // 获取四种分解
  final affine = XMatrixUtils.decomposeAffine(H);
  final qr = XMatrixUtils.qrDecomposition2D(H);
  final svd = XMatrixUtils.svdDecomposition2D(H);
  final full = XMatrixUtils.decomposeFull(H);

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

  final sv1 = XMatrixUtils2D.decomposeQR(H);
  final sv2 = XMatrixUtils2D.composeFromQR(sv1);

  matrixText.writeln("QR分解参数:");
  matrixText.writeln("  translationX = ${sv1.translationX}");
  matrixText.writeln("  translationY = ${sv1.translationY}");
  matrixText.writeln("  rotation = ${sv1.rotation * 180 / pi}°");
  matrixText.writeln("  scaleX = ${sv1.scaleX}");
  matrixText.writeln("  scaleY = ${sv1.scaleY}");
  matrixText.writeln("  skewX = ${sv1.skewX}");
  matrixText.writeln("  skewY = ${sv1.skewY}");
  matrixText.writeln("");

  matrixText.writeln("QR分解分解转换回矩阵:");
  matrixText.writeln(matrix4ToString(sv2));

  matrixText.writeln("0 -> 1 角度:");
  matrixText.writeln(rotation_0_1);
  matrixText.writeln("");

  matrixText.writeln("————————————————————————————————————");

  matrixText.writeln("decomposeAffine:");
  matrixText.writeln("  translation = ${affine['translation']}");
  matrixText.writeln("  rotation = ${(affine['rotation'] as double) * 180 / pi}°");
  matrixText.writeln("  scale = ${affine['scale']}");
  matrixText.writeln("  skew = ${affine['skew']}");
  matrixText.writeln("");

  matrixText.writeln("qrDecomposition2D:");
  matrixText.writeln("  rotation = ${(qr['rotation'] as double) * 180 / pi}°");
  matrixText.writeln("  scale = ${qr['scale']}");
  matrixText.writeln("  shear = ${qr['shear']}");
  matrixText.writeln("");

  matrixText.writeln("svdDecomposition2D:");
  matrixText.writeln("  rotation = ${(svd['rotation'] as double) * 180 / pi}°");
  matrixText.writeln("  scale = ${svd['scale']}");
  matrixText.writeln("");

  matrixText.writeln("decomposeFull:");
  matrixText.writeln("  translation = ${full['translation']}");
  matrixText.writeln("  rotation = ${(full['rotation'] as double) * 180 / pi}°");
  matrixText.writeln("  scale = ${full['scale']}");
  matrixText.writeln("  skew = ${full['skew']}");
  matrixText.writeln("  perspective = ${full['perspective']}");

  print(matrixText.toString());

  return matrixText.toString();
}
