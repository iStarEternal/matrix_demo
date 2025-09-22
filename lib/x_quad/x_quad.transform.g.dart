part of 'x_quad.dart';

extension XQuadExtTransform on XQuad {
  /// 平移
  XQuad translate(XPoint offset) {
    return XQuad(
      topLeft: XGeometryUtils.translate(topLeft, offset),
      bottomLeft: XGeometryUtils.translate(bottomLeft, offset),
      topRight: XGeometryUtils.translate(topRight, offset),
      bottomRight: XGeometryUtils.translate(bottomRight, offset),
    );
  }

  /// 缩放
  XQuad scale(double scaleX, double scaleY, XPoint center) {
    return XQuad(
      topLeft: XGeometryUtils.scale(topLeft, scaleX, scaleY, center),
      bottomLeft: XGeometryUtils.scale(bottomLeft, scaleX, scaleY, center),
      topRight: XGeometryUtils.scale(topRight, scaleX, scaleY, center),
      bottomRight: XGeometryUtils.scale(bottomRight, scaleX, scaleY, center),
    );
  }

  /// 旋转四边形的方法
  XQuad rotate(XPoint center, double radian) {
    return XQuad(
      topLeft: XGeometryUtils.rotate(topLeft, center, radian),
      bottomLeft: XGeometryUtils.rotate(bottomLeft, center, radian),
      topRight: XGeometryUtils.rotate(topRight, center, radian),
      bottomRight: XGeometryUtils.rotate(bottomRight, center, radian),
    );
  }
}
