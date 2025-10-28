import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';
import 'package:x_quad/src/x_matrix/x_matrix_utils.dart';

import '../x_geometry/x_geometry_utils.dart';
import 'x_point.dart';

part 'x_quad.geometry.part.dart';
part 'x_quad.matrix.part.dart';
part 'x_quad.transform.part.dart';

/// 四边形
/// XQuadrilateral
/// XQuadrangle
final class XQuad {
  final XPoint topLeft;
  final XPoint topRight;
  final XPoint bottomRight;
  final XPoint bottomLeft;

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

  @override
  String toString() {
    return toPoints().toString();
  }
}

extension XQuadExtCopy on XQuad {
  XQuad copy() {
    return XQuad(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft);
  }

  /// 复制
  /// 顺序：0 -> 1 ↓ 2 ← 3
  XQuad copyWith({XPoint? topLeft, XPoint? topRight, XPoint? bottomRight, XPoint? bottomLeft}) {
    return XQuad(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      bottomLeft: bottomLeft ?? this.bottomLeft, //
    );
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

  /// 替换指定 index 的点（返回新 Quad，不会修改原对象）
  /// 0 → 1
  /// ↑   ↓
  /// 3 ← 2
  XQuad updatePoint(int index, XPoint value) {
    switch (index) {
      case 0:
        return copyWith(topLeft: value);
      case 1:
        return copyWith(topRight: value);
      case 2:
        return copyWith(bottomRight: value);
      case 3:
        return copyWith(bottomLeft: value);
      default:
        throw ArgumentError('index 必须是 0~3，当前=$index');
    }
  }
}
