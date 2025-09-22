import 'package:flutter/material.dart';
import 'package:matrix_demo/x_quad/x_point.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

class TestConfig {
  static var from = [
    {"x": 0.0, "y": 0.0},
    {"x": 522.0, "y": 0.0},
    {"x": 522.0, "y": 172.0},
    {"x": 0.0, "y": 172.0},
  ];

  static var to = [
    {"x": 0.0, "y": 0.0},
    {"x": 522.0, "y": 0.0},
    {"x": 322.0, "y": 101.0},
    {"x": 0.0, "y": 172.0},
  ];

  static var H = [
    [3.022814103263835, 0, 0, 0],
    [0, 2.8775242877415126, 0, 0],
    [0, 0, 1, 0],
    [0.003875122803187424, 0.010915838882218098, 0, 1],
  ];

  static XQuad jsonToQuad(List<Map<String, double>> json) {
    final val = json.map((item) => XPoint(item['x'] as double, item['y'] as double)).toList();
    return XQuad(topLeft: val[0], topRight: val[1], bottomRight: val[2], bottomLeft: val[3]);
  }

  ds(BuildContext context) {
    return AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("你好"));
  }
}
