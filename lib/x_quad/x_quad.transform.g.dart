part of 'x_quad.dart';

extension XQuadExtTransform on XQuad {
  /// 平移（全部点）
  XQuad translate(XPoint offset) {
    return XQuad(
      topLeft: XGeometryUtils.translate(topLeft, offset),
      topRight: XGeometryUtils.translate(topRight, offset),
      bottomRight: XGeometryUtils.translate(bottomRight, offset),
      bottomLeft: XGeometryUtils.translate(bottomLeft, offset),
    );
  }

  /// 平移（可选修改部分点）
  XQuad translatePartial(XPoint offset, {bool changeTopLeft = false, bool changeTopRight = false, bool changeBottomRight = false, bool changeBottomLeft = false}) {
    return XQuad(
      topLeft: changeTopLeft ? XGeometryUtils.translate(topLeft, offset) : topLeft,
      topRight: changeTopRight ? XGeometryUtils.translate(topRight, offset) : topRight,
      bottomRight: changeBottomRight ? XGeometryUtils.translate(bottomRight, offset) : bottomRight,
      bottomLeft: changeBottomLeft ? XGeometryUtils.translate(bottomLeft, offset) : bottomLeft,
    );
  }

  /// 缩放
  XQuad scale(double scaleX, double scaleY, {XPoint? center}) {
    final currentCenter = center ?? this.center();
    return XQuad(
      topLeft: XGeometryUtils.scale(topLeft, scaleX, scaleY, currentCenter),
      topRight: XGeometryUtils.scale(topRight, scaleX, scaleY, currentCenter),
      bottomRight: XGeometryUtils.scale(bottomRight, scaleX, scaleY, currentCenter),
      bottomLeft: XGeometryUtils.scale(bottomLeft, scaleX, scaleY, currentCenter),
    );
  }

  /// 旋转（根据弧度）
  XQuad rotate(double radian, {XPoint? center}) {
    final currentCenter = center ?? this.center();
    return XQuad(
      topLeft: XGeometryUtils.rotate(topLeft, currentCenter, radian),
      topRight: XGeometryUtils.rotate(topRight, currentCenter, radian),
      bottomRight: XGeometryUtils.rotate(bottomRight, currentCenter, radian),
      bottomLeft: XGeometryUtils.rotate(bottomLeft, currentCenter, radian),
    );
  }

  /// 旋转（根据角度）
  XQuad rotateByDegree(double degree, {XPoint? center}) {
    return rotate(XGeometryUtils.degreeToRadian(degree), center: center);
  }
}
