import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' as vm;

/// 2D QR 分解参数对象
class XQRDecomposition2D {
  final double translationX;
  final double translationY;
  final double rotation; // 弧度
  final double scaleX;
  final double scaleY;
  final double skewX;
  final double skewY;

  XQRDecomposition2D({
    required this.translationX,
    required this.translationY,
    required this.rotation,
    required this.scaleX,
    required this.scaleY,
    required this.skewX,
    required this.skewY,
  });

  @override
  String toString() {
    return 'QRDecomposition2D(translation: ${Offset(translationX, translationY)}, rotation: ${rotation * 180 / pi}°, scaleX: $scaleX, scaleY: $scaleY, skewX: $skewX, skewY: $skewY)';
  }
}

class XMatrixDecomposition {
  XMatrixDecomposition._();

  /// QR 分解获取 2D 仿射矩阵参数
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

    return XQRDecomposition2D(translationX: tx, translationY: ty, rotation: rotation, scaleX: scaleX, scaleY: scaleY, skewX: skewX, skewY: skewY);
  }

  /// 使用 QR 分解的参数重建矩阵
  static vm.Matrix4 composeFromQR(XQRDecomposition2D params) {
    return composeFromQR_v2(params);
  }

  static vm.Matrix4 composeFromQR_v2(XQRDecomposition2D params) {
    final cosR = cos(params.rotation);
    final sinR = sin(params.rotation);

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

extension Dep on XMatrixDecomposition {
  ///
  static List<double> qrDecomposition(vm.Matrix4 matrix) {
    final sx = matrix.row0.x;
    final sy = matrix.row1.y;
    final kx = matrix.row0.y;
    final ky = matrix.row1.x;

    final radians = math.atan2(ky, sx);
    // final denom = sx.pow(2) + ky.pow(2);
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

  static vm.Matrix4 composeFromQR_v1(XQRDecomposition2D params) {
    final cosR = cos(params.rotation);
    final sinR = sin(params.rotation);

    // rotation 矩阵
    final rot = vm.Matrix4.identity();
    rot[0] = cosR;
    rot[1] = sinR;
    rot[4] = -sinR;
    rot[5] = cosR;

    // scale 矩阵
    final scale = vm.Matrix4.identity();
    scale[0] = params.scaleX;
    scale[5] = params.scaleY;

    // skew 矩阵
    final skew = vm.Matrix4.identity();
    skew[1] = params.skewX;
    skew[4] = params.skewY;

    // translation 矩阵
    final trans = vm.Matrix4.identity();
    trans[12] = params.translationX;
    trans[13] = params.translationY;

    // 合成矩阵：skew * scale * rotation * translation
    return skew * scale * rot * trans;
  }
}
