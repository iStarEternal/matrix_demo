import 'dart:ui';

/// XPoint
final class XPoint {
  final double x;
  final double y;

  XPoint(this.x, this.y);

  Offset toOffset() {
    return Offset(x, y);
  }

  @override
  String toString() {
    return 'Point($x, $y)';
  }

  // 支持 XPoint + Offset
  XPoint operator +(Offset offset) => XPoint(x + offset.dx, y + offset.dy);
}

extension OffsetExt on Offset {
  XPoint toPoint() {
    return XPoint(dx, dy);
  }
}
