import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' as vm;

/// Flutter 版 XMatrixUtils
class XMatrixUtils_v2 {
  XMatrixUtils_v2._();

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
}

extension ListSwap<T> on List<T> {
  void swap(int i, int j) {
    final tmp = this[i];
    this[i] = this[j];
    this[j] = tmp;
  }
}
