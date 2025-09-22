import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrix_demo/x_quad/x_point.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

import 'test_config.dart';
import 'affine_painter.dart';
import 'debug_test.dart';

class AffineDemoPage extends StatefulWidget {
  const AffineDemoPage({super.key});

  @override
  State<AffineDemoPage> createState() => _AffineDemoPageState();
}

class _AffineDemoPageState extends State<AffineDemoPage> {
  late XQuad quadA;
  late XQuad quadB;
  final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange];

  // 旋转角度记录
  double _lastRotationAngle = 0.0;

  @override
  void initState() {
    super.initState();
    resetQuads();
  }

  /// 重置四边形
  void resetQuads() {
    final result = TestConfig.test1();
    quadA = result.$1;
    quadB = result.$2;
  }

  void resetToZero() {
    final result = TestConfig.test1();
    quadA = result.$1;
    quadB = result.$1.copy();
  }

  @override
  Widget build(BuildContext context) {
    final rect = quadB.toOuterRect();
    final center = quadB.getCenter().toOffset();
    final handleSize = 28.0;

    return Scaffold(
      body: Container(
        color: Colors.cyan.shade50,
        child: Stack(
          children: [
            // 日志信息
            _buildLogWidget(),
            // 绘制 quad
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: AffinePainter(quadA: quadA, quadB: quadB, colors: colors),
            ),
            // 拖动角点
            ..._buildCornerHandles(),
            // 环绕操作按钮
            ..._buildAroundHandles(rect, center, handleSize),
            // 重置按钮
            Positioned(
              left: 16,
              bottom: 16,
              child: Row(
                spacing: 12,
                children: [
                  _resetToInitialButon(), //
                  _resetToZeroButon(), //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 计算中心到点的角度
  double _calculateAngle(Offset center, Offset pos) {
    return atan2(pos.dy - center.dy, pos.dx - center.dx);
  }

  /// 创建角点拖动控件
  List<Widget> _buildCornerHandles() {
    final offsets = quadB.toOffsets();
    return List.generate(offsets.length, (i) {
      return Positioned(
        left: offsets[i].dx - 12 / 2,
        top: offsets[i].dy - 12 / 2,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              quadB.setPoint(i, quadB.toPoints()[i] + details.delta);
            });
          },
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle),
          ),
        ),
      );
    });
  }

  /// 创建环绕按钮（拖动控制）
  List<Widget> _buildAroundHandles(Rect rect, Offset center, double handleSize) {
    final double gap = 40;
    return [
      // 上 - 旋转
      Positioned(left: center.dx - handleSize / 2, top: rect.top - gap - 80, child: _rotationHandle(center)),
      // X 缩放
      Positioned(left: rect.right + gap - handleSize / 2, top: center.dy - handleSize / 2 - 20, child: _scaleXHandle(center)),
      // Y 缩放
      Positioned(left: center.dx - handleSize / 2, top: rect.bottom + gap - handleSize / 2, child: _scaleYHandle(center)),
      // 平移（任意方向）
      Positioned(left: rect.right + gap - handleSize / 2, top: rect.bottom + gap - handleSize / 2, child: _translateHandle()),
    ];
  }

  /// 旋转按钮
  Widget _rotationHandle(Offset center) {
    return GestureDetector(
      onPanStart: (details) {
        _lastRotationAngle = _calculateAngle(center, details.globalPosition);
      },
      onPanUpdate: (details) {
        final currentAngle = _calculateAngle(center, details.globalPosition);
        final delta = currentAngle - _lastRotationAngle;
        setState(() {
          quadB = quadB.rotate(quadB.getCenter(), delta);
        });
        _lastRotationAngle = currentAngle;
      },
      child: _handle("旋转"),
    );
  }

  /// X 缩放按钮
  Widget _scaleXHandle(Offset center) {
    return GestureDetector(
      onPanUpdate: (details) {
        final scaleX = 1 + details.delta.dx / 100;
        setState(() {
          quadB = quadB.scale(scaleX, 1.0, center.toPoint());
        });
      },
      child: _handle("缩放宽"),
    );
  }

  /// Y 缩放按钮
  Widget _scaleYHandle(Offset center) {
    return GestureDetector(
      onPanUpdate: (details) {
        final scaleY = 1 + details.delta.dy / 100;
        setState(() {
          quadB = quadB.scale(1.0, scaleY, center.toPoint());
        });
      },
      child: _handle("缩放高"),
    );
  }

  /// 平移按钮（任意方向）
  Widget _translateHandle() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          quadB = quadB.translate(details.delta.toPoint());
        });
      },
      child: _handle("平移"),
    );
  }

  /// 通用圆形按钮
  Widget _handle(String text) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.indigoAccent),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLogWidget() {
    final offsetsA = quadA.toOffsets();
    final offsetsB = quadB.toOffsets();
    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 500,
        color: Colors.white.withOpacity(0.7),
        child: SingleChildScrollView(
          child: Text(logText(offsetsA, offsetsB), style: const TextStyle(fontSize: 12, color: Colors.black)),
        ),
      ),
    );
  }

  Widget _resetToInitialButon() {
    return ElevatedButton(
      onPressed: () {
        resetQuads();
        setState(() {});
      },
      child: Text("初始化"),
    );
  }

  Widget _resetToZeroButon() {
    return ElevatedButton(
      onPressed: () {
        resetToZero();
        setState(() {});
      },
      child: Text("归零"),
    );
  }
}
