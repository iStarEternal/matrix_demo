import 'package:matrix_demo/x_matrix/v2_android.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'x_qr_decomposition_2d.dart';

export 'x_qr_decomposition_2d.dart';

class XMatrixDecomposition {
  XMatrixDecomposition._();

  /// QR 分解获取 仿射矩2D 阵参数
  static XQRDecomposition2D decomposeQR(vm.Matrix4 m) {
    return XMatrixDecompositionAndroid.decomposeQR(m);
  }

  /// 使用 QR 分解的参数重建矩阵
  static vm.Matrix4 composeFromQR(XQRDecomposition2D params) {
    return XMatrixDecompositionAndroid.composeFromQR(params);
  }
}
