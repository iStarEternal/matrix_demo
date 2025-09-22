import 'package:flutter/material.dart';
import 'package:matrix_demo/debug_print.dart';
import 'package:matrix_demo/x_quad/x_quad.dart';

import 'TestConfig.dart';
import 'affine_painter.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: AffineDemoPage())));
}

class AffineDemoPage extends StatefulWidget {
  const AffineDemoPage({super.key});

  @override
  State<AffineDemoPage> createState() => _AffineDemoPageState();
}

class _AffineDemoPageState extends State<AffineDemoPage> {
  late XQuad quadA;

  late XQuad quadB;

  final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange];

  @override
  void initState() {
    super.initState();

    // B = XDrawBoxUtils.rotatePoints(B, XRotationUtils.degreeToRadian(-50));

    resetQuads();
  }

  resetQuads() {
    quadA = TestConfig.jsonToQuad(TestConfig.from);
    quadB = TestConfig.jsonToQuad(TestConfig.to);
    print(quadA);
    print(quadB);
  }

  @override
  Widget build(BuildContext context) {
    final offsetsA = quadA.toOffsets();
    final offsetsB = quadB.toOffsets();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Container(
        color: Colors.cyan.shade50,
        child: Stack(
          children: [
            Positioned(
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
            ),
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: AffinePainter(quadA: quadA, quadB: quadB, colors: colors),
            ),
            for (int i = 0; i < offsetsB.length; i++)
              Positioned(
                left: offsetsB[i].dx - 12 / 2,
                top: offsetsB[i].dy - 12 / 2,
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
              ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Row(
                children: [
                  resetWidgetA(),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetWidgetA() {
    return ElevatedButton(
      onPressed: () {},
      child: Text("重置"),
      //
    );
  }
}
