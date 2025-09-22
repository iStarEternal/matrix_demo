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
}
