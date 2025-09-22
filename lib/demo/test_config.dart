import 'dart:ui';

import 'package:matrix_demo/x_geometry/x_geometry_utils.dart';
import 'package:matrix_demo/x_quad/x_point.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

class TestConfig {
  static (XQuad from, XQuad to) test1() {
    final List<Offset> from = [
      const Offset(50, 100), const Offset(150, 100), const Offset(150, 200), const Offset(50, 200), //
    ];

    final List<Offset> to = [
      // const Offset(50, 100), const Offset(150, 100), const Offset(150, 200), const Offset(50, 200), //
      const Offset(200, 200), const Offset(300, 200), const Offset(250, 300), const Offset(150, 300), //
    ];

    final quadFrom = _offsetsToQuad(from);
    var quadTo = _offsetsToQuad(to);
    quadTo = quadTo.rotate(quadTo.getCenter(), XGeometryUtils.degreeToRadian(50));

    return (quadFrom, quadTo);
  }

  static (XQuad from, XQuad to) test2() {
    var from = [
      {"x": 0.0, "y": 0.0},
      {"x": 522.0, "y": 0.0},
      {"x": 522.0, "y": 172.0},
      {"x": 0.0, "y": 172.0},
    ];

    var to = [
      {"x": 0.0, "y": 0.0},
      {"x": 522.0, "y": 0.0},
      {"x": 322.0, "y": 101.0},
      {"x": 0.0, "y": 172.0},
    ];

    List<List<double>> H = [
      [3.022814103263835, 0, 0, 0],
      [0, 2.8775242877415126, 0, 0],
      [0, 0, 1, 0],
      [0.003875122803187424, 0.010915838882218098, 0, 1],
    ];

    final quadFrom = _jsonToQuad(from);
    final quadTo = _jsonToQuad(to);

    return (quadFrom, quadTo);
  }

  static XQuad _jsonToQuad(List<Map<String, double>> json) {
    final val = json.map((item) => XPoint(item['x'] as double, item['y'] as double)).toList();
    return XQuad(topLeft: val[0], topRight: val[1], bottomRight: val[2], bottomLeft: val[3]);
  }

  static XQuad _offsetsToQuad(List<Offset> val) {
    return XQuad(topLeft: val[0].toPoint(), topRight: val[1].toPoint(), bottomRight: val[2].toPoint(), bottomLeft: val[3].toPoint());
  }
}
