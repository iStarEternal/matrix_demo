import 'dart:math';
import 'dart:ui';

import '../x_quad/x_point.dart';

/// 几何
class XGeometryUtils {
  XGeometryUtils._();

  /// 将弧度 (radian) 转换为角度 (degree)
  /// 例如：弧度 π/2 转换为 90 度
  static double radianToDegree(double radian) {
    return radian * 180 / pi;
  }

  /// 将角度 (degree) 转换为弧度 (radian)
  /// 例如：90 度 转换为 π/2 弧度
  static double degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  /// 获取点 A 到点 B 的方向角（弧度）
  static double angleBetweenPoints(Offset pointA, Offset pointB) {
    final dx = pointB.dx - pointA.dx;
    final dy = pointB.dy - pointA.dy;
    return atan2(dy, dx);
  }

  /// 获取点 A 到点 B 的方向角（角度）
  static double angleBetweenPointsDegree(Offset pointA, Offset pointB) {
    return radianToDegree(angleBetweenPoints(pointA, pointB));
  }

  /// 平移
  static XPoint translate(XPoint point, XPoint offset) {
    return XPoint(point.x + offset.x, point.y + offset.y);
  }

  /// 缩放
  static XPoint scale(XPoint point, double scaleX, double scaleY, XPoint center) {
    return XPoint((point.x - center.x) * scaleX + center.x, (point.y - center.y) * scaleY + center.y);
  }

  /// 将指定点绕中心旋转 旋转点的方法
  static XPoint rotate(XPoint point, double radian, XPoint center) {
    double cosAngle = cos(radian);
    double sinAngle = sin(radian);

    // 平移点到原点
    double translatedX = point.x - center.x;
    double translatedY = point.y - center.y;

    // 旋转点
    double rotatedX = translatedX * cosAngle - translatedY * sinAngle;
    double rotatedY = translatedX * sinAngle + translatedY * cosAngle;

    // 平移回去
    return XPoint(rotatedX + center.x, rotatedY + center.y);
  }
}
