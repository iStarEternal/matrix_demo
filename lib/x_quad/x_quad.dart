import 'dart:ui';

import 'package:matrix_demo/x_matrix/x_matrix_utils.dart';
import 'package:vector_math/vector_math_64.dart';

import '../x_geometry/x_geometry_utils.dart';
import 'x_point.dart';

part 'x_quad.geometry.g.dart';
part 'x_quad.matrix.g.dart';
part 'x_quad.transform.g.dart';

/// 四边形
/// XQuadrilateral
/// XQuadrangle
final class XQuad {
  XPoint topLeft;
  XPoint topRight;
  XPoint bottomRight;
  XPoint bottomLeft;

  XQuad({required this.topLeft, required this.topRight, required this.bottomRight, required this.bottomLeft});

  factory XQuad.fromRect(Rect fromRect) {
    return XQuad(
      topLeft: XPoint(fromRect.topLeft.dx, fromRect.topLeft.dy),
      topRight: XPoint(fromRect.topRight.dx, fromRect.topRight.dy),
      bottomRight: XPoint(fromRect.bottomRight.dx, fromRect.bottomRight.dy),
      bottomLeft: XPoint(fromRect.bottomLeft.dx, fromRect.bottomLeft.dy),
    );
  }

  factory XQuad.fromMatrix(Matrix4 fromMatrix, Rect rect) {
    final topLeft = fromMatrix.transform(Vector4(rect.left, rect.top, 0.0, 1.0));
    final topRight = fromMatrix.transform(Vector4(rect.right, rect.top, 0.0, 1.0));
    final bottomRight = fromMatrix.transform(Vector4(rect.right, rect.bottom, 0.0, 1.0));
    final bottomLeft = fromMatrix.transform(Vector4(rect.left, rect.bottom, 0.0, 1.0));
    return XQuad(
      topLeft: XPoint(topLeft.x, topLeft.y),
      topRight: XPoint(topRight.x, topRight.y),
      bottomRight: XPoint(bottomRight.x, bottomRight.y),
      bottomLeft: XPoint(bottomLeft.x, bottomLeft.y),
      //
    );
  }

  XQuad copy() {
    return XQuad(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft);
  }

  @override
  String toString() {
    return toPoints().toString();
  }
}

// XQuad 扩展方法，方便更新点
extension XQuadSetter on XQuad {
  /// 按照上右下左的方式，获取点列表
  /// 0 → 1
  /// ↑   ↓
  /// 3 ← 2
  List<XPoint> toPoints() => [topLeft, topRight, bottomRight, bottomLeft];

  List<Offset> toOffsets() => toPoints().map((p) => p.toOffset()).toList();

  void setPoint(int index, XPoint value) {
    switch (index) {
      case 0:
        topLeft = value;
        break;
      case 1:
        topRight = value;
        break;
      case 2:
        bottomRight = value;
        break;
      case 3:
        bottomLeft = value;
        break;
    }
  }
}
