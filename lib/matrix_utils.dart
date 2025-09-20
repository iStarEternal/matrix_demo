import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' as vm;

/// Flutter 版 XMatrixUtils
class XMatrixUtils {
  XMatrixUtils._();

  /// 透视矩阵 from 4 点到 4 点
  static vm.Matrix4 getMatrix4(List<Offset> from, List<Offset> to) {
    assert(from.length == 4 && to.length == 4);

    final a = <List<double>>[];
    final b = <double>[];

    for (int i = 0; i < 4; i++) {
      a.add([from[i].dx, from[i].dy, 1, 0, 0, 0, -from[i].dx * to[i].dx, -from[i].dy * to[i].dx]);
      a.add([0, 0, 0, from[i].dx, from[i].dy, 1, -from[i].dx * to[i].dy, -from[i].dy * to[i].dy]);

      b.add(to[i].dx);
      b.add(to[i].dy);
    }

    final h = _solveLinearSystem(a, b);

    return vm.Matrix4(h[0], h[3], 0, h[6], h[1], h[4], 0, h[7], 0, 0, 1, 0, h[2], h[5], 0, 1);
  }

  /// 高斯消元求解 8x8
  static List<double> _solveLinearSystem(List<List<double>> A, List<double> b) {
    final n = A.length;
    for (int i = 0; i < n; i++) {
      A[i] = [...A[i], b[i]]; // 增广矩阵
    }

    for (int i = 0; i < n; i++) {
      int maxRow = i;
      double maxEl = A[i][i].abs();
      for (int k = i + 1; k < n; k++) {
        if (A[k][i].abs() > maxEl) {
          maxEl = A[k][i].abs();
          maxRow = k;
        }
      }
      if (maxRow != i) A.swap(maxRow, i);

      for (int k = i + 1; k < n; k++) {
        double c = -A[k][i] / A[i][i];
        for (int j = i; j < n + 1; j++) {
          A[k][j] += c * A[i][j];
        }
      }
    }

    final x = List.filled(n, 0.0);
    for (int i = n - 1; i >= 0; i--) {
      x[i] = A[i][n] / A[i][i];
      for (int k = i - 1; k >= 0; k--) {
        A[k][n] -= A[k][i] * x[i];
      }
    }
    return x;
  }

  /// 直接仿射分解
  static Map<String, dynamic> decomposeAffine(vm.Matrix4 m) {
    final tx = m[12];
    final ty = m[13];
    final scaleX = sqrt(m[0] * m[0] + m[1] * m[1]);
    final scaleY = sqrt(m[4] * m[4] + m[5] * m[5]);
    final rotation = atan2(m[1], m[0]);
    final skewX = atan2(-m[4], m[5]);
    final skewY = atan2(m[1], m[0]);
    return {'translation': Offset(tx, ty), 'rotation': rotation, 'scale': Size(scaleX, scaleY), 'skew': Size(skewX, skewY)};
  }

  /// QR 分解 2D
  static Map<String, dynamic> qrDecomposition2D(vm.Matrix4 m) {
    final a = m[0], b = m[1];
    final c = m[4], d = m[5];

    final theta = atan2(c, a);
    final cosT = cos(theta), sinT = sin(theta);

    final r11 = cosT, r12 = -sinT;
    final r21 = sinT, r22 = cosT;

    final q11 = r11 * a + r12 * c;
    final q12 = r11 * b + r12 * d;
    final q22 = r21 * b + r22 * d;

    final scaleX = q11;
    final scaleY = q22;
    final shear = q12 / q22;

    return {'rotation': theta, 'scale': Size(scaleX, scaleY), 'shear': shear};
  }

  /// 2x2 闭式 SVD
  static Map<String, dynamic> svd2x2(vm.Matrix2 m) {
    final a = m.entry(0, 0), b = m.entry(0, 1);
    final c = m.entry(1, 0), d = m.entry(1, 1);

    final s1 = sqrt((a * a + b * b + c * c + d * d + sqrt(pow(a * a + b * b - c * c - d * d, 2) + 4 * pow(a * c + b * d, 2))) / 2);
    final s2 = sqrt((a * a + b * b + c * c + d * d - sqrt(pow(a * a + b * b - c * c - d * d, 2) + 4 * pow(a * c + b * d, 2))) / 2);

    return {
      'S': [s1, s2],
    };
  }

  /// SVD 分解 2D
  static Map<String, dynamic> svdDecomposition2D(vm.Matrix4 m) {
    final mat = vm.Matrix2(m[0], m[1], m[4], m[5]);
    final svd = svd2x2(mat);
    // 旋转用 U 的方向近似
    final angle = atan2(mat.entry(1, 0), mat.entry(0, 0));
    final s = svd['S'] as List<double>;
    return {'rotation': angle, 'scale': Size(s[0], s[1])};
  }

  /// 完全分解
  static Map<String, dynamic> decomposeFull(vm.Matrix4 m) {
    final tx = m[12];
    final ty = m[13];
    final px = m[3];
    final py = m[7];
    final scaleX = sqrt(m[0] * m[0] + m[1] * m[1]);
    final scaleY = sqrt(m[4] * m[4] + m[5] * m[5]);
    final rotation = atan2(m[1], m[0]);
    final skewX = atan2(-m[4], m[5]);
    final skewY = atan2(m[1], m[0]);
    return {'translation': Offset(tx, ty), 'rotation': rotation, 'scale': Size(scaleX, scaleY), 'skew': Size(skewX, skewY), 'perspective': Offset(px, py)};
  }
}

extension ListSwap<T> on List<T> {
  void swap(int i, int j) {
    final tmp = this[i];
    this[i] = this[j];
    this[j] = tmp;
  }
}
