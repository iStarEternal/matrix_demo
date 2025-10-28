import 'dart:math' as math;

import 'package:flutter/material.dart' as vm;
import 'package:x_quad/src/x_matrix/matrix_4_ext.dart';
import 'package:x_quad/src/x_matrix/x_qr_decomposition_2d.dart';

/// 取自安卓的算法
abstract class XMatrixDecompositionAndroid {
  /// 将 Matrix4 分解为 [translateX, translateY, radians(弧度), scaleX, scaleY, skewX(弧度), skewY(始终0), flipX, flipY]
  static XQRDecomposition2D decomposeQR(vm.Matrix4 matrix) {
    // 1. 提取基础参数
    // Flutter Matrix4 的存储顺序是 column-major
    // | m00 m04 m08 m12 |
    // | m01 m05 m09 m13 |
    // | m02 m06 m10 m14 |
    // | m03 m07 m11 m15 |
    final sx = matrix.scaleX; // scaleX 分量
    final sy = matrix.scaleY; // scaleY 分量
    final kx = matrix.skewXY; // skewX 分量
    final ky = matrix.skewYX; // skewY 分量
    final tx = matrix.translateX;
    final ty = matrix.translateY;

    // 2. 计算旋转角度 (radians)
    final radians = math.atan2(ky, sx);

    // 3. 计算 scaleX 和 scaleY
    final denom = math.pow(sx, 2) + math.pow(ky, 2);
    final scaleX = math.sqrt(denom);
    final scaleY = (sx * sy - kx * ky) / scaleX;

    // 4. 计算 skewX, skewY
    final skewX = math.atan2(sx * kx + ky * sy, denom);
    const skewY = 0.0; // 固定为0（与安卓一致）

    // 5. 计算是否翻转
    final flipX = scaleX < 0;
    final flipY = scaleY < 0;

    // 6. 返回结果
    return XQRDecomposition2D(
      translationX: tx,
      translationY: ty,
      radians: radians,
      scaleX: scaleX,
      scaleY: scaleY,
      flipX: flipX,
      flipY: flipY,
      skewX: skewX,
      skewY: skewY,
    );
  }

  static vm.Matrix4 composeFromQR(XQRDecomposition2D params) {
    final vm.Matrix4 translate = vm.Matrix4.identity()..translateByDouble(params.translationX, params.translationY, 0, 1);
    final vm.Matrix4 rotation = vm.Matrix4.identity()..rotateZ(params.radians);
    final vm.Matrix4 scale = vm.Matrix4.identity()..scaleByDouble(params.scaleX, params.scaleY, 1, 1);
    final vm.Matrix4 flip = vm.Matrix4.identity()..scaleByDouble(params.flipX ? -1 : 1, params.flipY ? -1 : 1, 1, 1);
    final vm.Matrix4 skew = vm.Matrix4.skew(params.skewX, params.skewY);
    return translate * rotation * scale * flip * skew;
  }
}

abstract class _Dep {
  // hky 在 flutter 中写的现成的
  List<double> qrDecomposition(vm.Matrix4 matrix) {
    final sx = matrix.scaleX;
    final sy = matrix.scaleY;
    final kx = matrix.skewXY;
    final ky = matrix.skewYX;

    final radians = math.atan2(ky, sx);
    final denom = math.pow(sx, 2) + math.pow(ky, 2);

    final scaleX = math.sqrt(denom);
    final scaleY = (sx * sy - kx * ky) / scaleX;

    //x倾斜的角度, 弧度单位
    final skewX = math.atan2(sx * kx + ky * sy, denom);
    //y倾斜的角度, 弧度单位, 始终为0, 这是关键.
    const skewY = 0.0;

    //updateAngle(angle);
    final resultRadians = radians; //旋转的角度, 弧度单位
    //final resultFlipX = scaleX < 0; //是否x翻转
    //final resultFlipY = scaleY < 0; //是否y翻转
    final resultScaleX = scaleX; //x缩放比例
    final resultScaleY = scaleY; //y缩放比例
    final resultSkewX = skewX;
    const resultSkewY = skewY;
    return [
      resultRadians, //弧度
      resultScaleX, //正负值
      resultScaleY, //正负值
      resultSkewX, //弧度
      resultSkewY, //始终为0
    ];
  }
}
