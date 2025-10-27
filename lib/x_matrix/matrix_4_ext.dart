import 'package:vector_math/vector_math_64.dart' as vm;

extension Matrix4Ext on vm.Matrix4 {
  /*
   * Matrix4 4x4 结构（列主序，Flutter / vector_math 约定）：
   *
   * | m00 m04 m08 m12 |  | scaleX,         skewXY,         perspectiveX,   translateX    |
   * | m01 m05 m09 m13 |  | skewYX,         scaleY,         perspectiveY,   translateY    |
   * | m02 m06 m10 m14 |  | skewZX,         skewZY,         scaleZ,         translateZ    |
   * | m03 m07 m11 m15 |  | perspectiveWX,  perspectiveWY,  perspectiveWZ,  perspectiveW  |
   */

  // -------- 第一行 --------
  /// X轴缩放因子
  double get scaleX => entry(0, 0);

  /// X轴相对于Y轴的倾斜
  double get skewXY => entry(0, 1);

  /// X方向透视分量
  double get perspectiveX => entry(0, 2);

  /// X轴平移量
  double get translateX => entry(0, 3);

  // -------- 第二行 --------
  /// Y轴相对于X轴的倾斜
  double get skewYX => entry(1, 0);

  /// Y轴缩放因子
  double get scaleY => entry(1, 1);

  /// Y方向透视分量
  double get perspectiveY => entry(1, 2);

  /// Y轴平移量
  double get translateY => entry(1, 3);

  // -------- 第三行 --------
  /// Z轴相对于X轴的倾斜
  double get skewZX => entry(2, 0);

  /// Z轴相对于Y轴的倾斜
  double get skewZY => entry(2, 1);

  /// Z轴缩放因子
  double get scaleZ => entry(2, 2);

  /// Z轴平移量（深度平移）
  double get translateZ => entry(2, 3);

  // -------- 第四行 --------
  /// W分量透视项对应X
  double get perspectiveWX => entry(3, 0);

  /// W分量透视项对应Y
  double get perspectiveWY => entry(3, 1);

  /// W分量透视项对应Z
  double get perspectiveWZ => entry(3, 2);

  /// W分量齐次坐标
  double get perspectiveW => entry(3, 3);
}
