import 'dart:math' as math;
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart' as vm;

// 参考：https://franklinta.com/2014/09/08/computing-css-matrix3d-transforms/

class XMatrixUtils {
  /// 仿射变化，通过from4Point，和to4Points，得到矩阵
  static vm.Matrix4 getMatrix4(List<Offset> from, List<Offset> to) {
    assert(from.length == 4 && to.length == 4);

    List<List<double>> A = []; // 8x8 matrix
    for (int i = 0; i < 4; i++) {
      A.add([from[i].dx, from[i].dy, 1, 0, 0, 0, -from[i].dx * to[i].dx, -from[i].dy * to[i].dx]);
      A.add([0, 0, 0, from[i].dx, from[i].dy, 1, -from[i].dx * to[i].dy, -from[i].dy * to[i].dy]);
    }

    List<double> b = []; // 8x1 vector
    for (int i = 0; i < 4; i++) {
      b.add(to[i].dx);
      b.add(to[i].dy);
    }

    // Solve A * h = b for h (homogeneous coordinates)
    List<double> h = solve(A, b);

    // Construct the transformation matrix H
    List<List<double>> H = [
      [h[0], h[1], 0, h[2]],
      [h[3], h[4], 0, h[5]],
      [0, 0, 1, 0],
      [h[6], h[7], 0, 1],
    ];

    return vm.Matrix4.fromList([
      H[0][0],
      H[1][0],
      H[2][0],
      H[3][0],
      H[0][1],
      H[1][1],
      H[2][1],
      H[3][1],
      H[0][2],
      H[1][2],
      H[2][2],
      H[3][2],
      H[0][3],
      H[1][3],
      H[2][3],
      H[3][3],
    ]);
  }

  /// 逆仿射变化，通过from4Point和matrix，得到to4Points
  static List<Offset> getToPoints(List<Offset> fromPoints, vm.Matrix4 matrix) {
    List<Offset> toPoints = [];
    for (Offset point in fromPoints) {
      // 将点转换为齐次坐标
      vm.Vector4 homogeneousPoint = vm.Vector4(point.dx, point.dy, 0, 1);
      // 应用变换矩阵
      vm.Vector4 transformedPoint = matrix.transform(homogeneousPoint);
      // 将齐次坐标转换回笛卡尔坐标
      double w = transformedPoint.w;
      if (w != 0) {
        toPoints.add(Offset(transformedPoint.x / w, transformedPoint.y / w));
      } else {
        toPoints.add(Offset(double.nan, double.nan)); // 或者处理为其他合适的值
      }
    }
    return toPoints;
  }

  /// 线性方程组求解
  static List<double> solve(List<List<double>> A, List<double> b) {
    int n = A.length;

    // 增强矩阵 A，将常数项 b 添加到 A 的最后一列
    for (int i = 0; i < n; i++) {
      A[i].add(b[i]);
    }

    // 前向消元
    for (int i = 0; i < n; i++) {
      // 找到当前列中的最大元素
      double maxEl = A[i][i].abs();
      int maxRow = i;
      for (int k = i + 1; k < n; k++) {
        if (A[k][i].abs() > maxEl) {
          maxEl = A[k][i].abs();
          maxRow = k;
        }
      }

      // 如果主元素为零，则跳过此行
      if (maxEl < 1e-10) {
        return List<double>.filled(n, double.nan);
      }

      // 将最大行与当前行交换
      if (maxRow != i) {
        List<double> temp = A[maxRow];
        A[maxRow] = A[i];
        A[i] = temp;
      }

      // 使主元素下方的元素等于零
      for (int k = i + 1; k < n; k++) {
        double c = -A[k][i] / A[i][i]; // 计算消元因子
        for (int j = i; j < n + 1; j++) {
          if (i == j) {
            A[k][j] = 0; // 主对角线元素置为零
          } else {
            A[k][j] += c * A[i][j]; // 更新当前行
          }
        }
      }
    }

    // 回代过程
    List<double> x = List<double>.filled(n, 0); // 初始化解向量
    for (int i = n - 1; i >= 0; i--) {
      x[i] = A[i][n] / A[i][i]; // 计算每个变量的值
      for (int k = i - 1; k >= 0; k--) {
        A[k][n] -= A[k][i] * x[i]; // 更新前面行的常数项
      }
    }

    return x; // 返回解向量
  }
}
