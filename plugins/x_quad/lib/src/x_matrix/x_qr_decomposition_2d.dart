/// 2D QR 分解参数对象
class XQRDecomposition2D {
  final double translationX; // 平移X
  final double translationY; // 平移Y
  final double radians; // 弧度
  final double scaleX; // 缩放X
  final double scaleY; // 缩放Y
  final bool flipX; // 镜像X
  final bool flipY; // 镜像Y
  final double skewX; // 倾度X
  final double skewY; // 倾度Y

  XQRDecomposition2D({
    required this.translationX,
    required this.translationY,
    required this.radians,
    required this.scaleX,
    required this.scaleY,
    required this.flipX,
    required this.flipY,
    required this.skewX,
    required this.skewY,
  });

  @override
  String toString() {
    return 'QRDecomposition2D(translationX: $translationX, translationY: $translationY, radians: $radians, scaleX: $scaleX, scaleY: $scaleY, flipX: $flipX, flipY: $flipY, skewX: $skewX, skewY: $skewY)';
  }
}
