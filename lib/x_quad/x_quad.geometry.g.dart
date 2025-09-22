part of 'x_quad.dart';

extension XQuadExtGeometry1 on XQuad {
  /// 计算四边形中心点的方法
  XPoint center() {
    double centerX = (topLeft.x + bottomLeft.x + topRight.x + bottomRight.x) / 4;
    double centerY = (topLeft.y + bottomLeft.y + topRight.y + bottomRight.y) / 4;
    return XPoint(centerX, centerY);
  }

  /// 获取最外层矩形
  Rect outerRect() {
    double minX = [topLeft.x, topRight.x, bottomLeft.x, bottomRight.x].reduce((a, b) => a < b ? a : b);
    double maxX = [topLeft.x, topRight.x, bottomLeft.x, bottomRight.x].reduce((a, b) => a > b ? a : b);
    double minY = [topLeft.y, topRight.y, bottomLeft.y, bottomRight.y].reduce((a, b) => a < b ? a : b);
    double maxY = [topLeft.y, topRight.y, bottomLeft.y, bottomRight.y].reduce((a, b) => a > b ? a : b);
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
