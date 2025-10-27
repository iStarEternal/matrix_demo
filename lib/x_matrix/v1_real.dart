import 'dart:math';

import 'package:flutter/cupertino.dart' as vm;
import 'package:matrix_demo/x_matrix/x_matrix_decomposition.dart';

/*
   * Matrix4 4x4 结构（列主序，Flutter / vector_math 约定）：
   *
   * | m00 m04 m08 m12 |  | scaleX,         skewXY,         perspectiveX,   translateX    |
   * | m01 m05 m09 m13 |  | skewYX,         scaleY,         perspectiveY,   translateY    |
   * | m02 m06 m10 m14 |  | skewZX,         skewZY,         scaleZ,         translateZ    |
   * | m03 m07 m11 m15 |  | perspectiveWX,  perspectiveWY,  perspectiveWZ,  perspectiveW  |
   */

abstract class XMatrixDecomposition_Real {
  /// QR 分解获取 仿射矩2D 阵参数
  static XQRDecomposition2D decomposeQR(vm.Matrix4 m) {
    final a = m[0], b = m[1];
    final c = m[4], d = m[5];
    final tx = m[12], ty = m[13];

    final scaleX = sqrt(a * a + b * b);
    final rotation = atan2(b, a);

    final cosR = cos(rotation);
    final sinR = sin(rotation);

    // 去除旋转，得到纯上三角矩阵 R
    final r11 = a * cosR + b * sinR;
    final r12 = -a * sinR + b * cosR;
    final r21 = c * cosR + d * sinR;
    final r22 = -c * sinR + d * cosR;

    final scaleY = r22;
    final skewX = r12 / scaleY;
    final skewY = r21 / scaleX;

    final flipX = scaleX < 0;
    final flipY = scaleY < 0;

    return XQRDecomposition2D(
      translationX: tx,
      translationY: ty,
      radians: rotation,
      scaleX: scaleX,
      scaleY: scaleY,
      flipX: flipX,
      flipY: flipY,
      skewX: skewX,
      skewY: skewY,
    );
  }

  /// 使用 QR 分解的参数重建矩阵
  static vm.Matrix4 composeFromQR(XQRDecomposition2D params) {
    final cosR = cos(params.radians);
    final sinR = sin(params.radians);

    // rotation + scale + skew
    final m = vm.Matrix4.identity();
    m[0] = params.scaleX * cosR; // m00
    m[1] = params.scaleX * sinR; // m01
    m[4] = params.scaleY * params.skewY * cosR - params.scaleY * sinR; // m10
    m[5] = params.scaleY * params.skewY * sinR + params.scaleY * cosR; // m11

    m[12] = params.translationX; // tx
    m[13] = params.translationY; // ty

    return m;
  }
}
