part of 'x_quad.dart';

extension XQuadExtMatrix on XQuad {
  /// 转成矩阵（使用四边形转
  Matrix4 toMatrix(XQuad fromQuad) {
    final fromPoints = fromQuad.toPoints();
    final toPoints = this.toPoints();
    return XMatrixUtils.getMatrix4(fromPoints.map((e) => e.toOffset()).toList(), toPoints.map((e) => e.toOffset()).toList());
  }

  /// 转成矩阵（使用Rect转
  Matrix4 toMatrixWithRect(Rect fromRect) {
    return toMatrix(XQuad.fromRect(fromRect));
  }

  XQuad applyMatrix(Matrix4 matrix) {
    final toTopLeft = matrix.transform(Vector4(topLeft.x, topLeft.y, 0.0, 1.0));
    final toTopRight = matrix.transform(Vector4(topRight.x, topRight.y, 0.0, 1.0));
    final toBottomRight = matrix.transform(Vector4(bottomRight.x, bottomRight.y, 0.0, 1.0));
    final toBottomLeft = matrix.transform(Vector4(bottomLeft.x, bottomLeft.y, 0.0, 1.0));
    return XQuad(
      topLeft: XPoint(toTopLeft.x, toTopLeft.y),
      topRight: XPoint(toTopRight.x, toTopRight.y),
      bottomRight: XPoint(toBottomRight.x, toBottomRight.y),
      bottomLeft: XPoint(toBottomLeft.x, toBottomLeft.y),
    );
  }
}
