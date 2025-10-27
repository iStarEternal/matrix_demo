import 'dart:ui';

import 'package:matrix_demo/x_matrix/x_matrix_decomposition.dart';
import 'package:matrix_demo/x_quad/x_point.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

class TestConfig {
  static (XQuad from, XQuad to) test1() {
    final List<Offset> from = [
      const Offset(0, 0), const Offset(150, 0), const Offset(150, 100), const Offset(0, 100), //
    ];

    final quadFrom = _offsetsToQuad(from);
    final quadTo = quadFrom
        .translate(XPoint(200, 200)) // 全点平移
        .translatePartial(XPoint(50, 0), changeTopLeft: true, changeTopRight: true) // 顶边平移
        .rotateByDegree(-50) // 旋转50度
        .scale(1.5, 1.2); // x放大1.2，y放大1.5
    return (quadFrom, quadTo);
  }

  static (XQuad from, XQuad to) test2() {
    // final qrd = XQRDecomposition2D(
    //   translationX: 290.827353,
    //   translationY: 100.8906555,
    //   rotation: XGeometryUtils.degreeToRadian(119.75867),
    //   scaleX: 2.0750246,
    //   scaleY: 0.83275247,
    //   skewX: XGeometryUtils.degreeToRadian(20.551098),
    //   skewY: 0,
    // );
    final qrdBefore = XQRDecomposition2D(
      translationX: 290.827353,
      translationY: 100.8906555,
      radians: 2.0901830993093573,
      scaleX: 2.0750246,
      scaleY: 0.83275247,
      flipX: false,
      flipY: false,
      skewX: 0.35868432500002156,
      skewY: 0,
    );

    print("before: ${qrdBefore}");
    final matrix = XMatrixDecomposition.composeFromQR(qrdBefore);
    final qrdAfter = XMatrixDecomposition.decomposeQR(matrix);
    print("after:  ${qrdAfter}");
    final fromQ = XQuad.fromRect(Rect.fromLTWH(0, 0, 100, 100));
    final toQ = fromQ.applyMatrix(matrix);

    return (fromQ, toQ);
  }

  static XQuad _offsetsToQuad(List<Offset> val) {
    return XQuad(topLeft: val[0].toPoint(), topRight: val[1].toPoint(), bottomRight: val[2].toPoint(), bottomLeft: val[3].toPoint());
  }
}
