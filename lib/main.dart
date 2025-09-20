import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrix_demo/XMatrixUtils2D.dart';
import 'package:matrix_demo/debug_print.dart';

import 'Geee.dart';
import 'affine_painter.dart';
import 'matrix_utils.dart';

void main() {
  runApp(const MaterialApp(home: Scaffold(body: AffineDemoPage())));
}

class AffineDemoPage extends StatefulWidget {
  const AffineDemoPage({super.key});

  @override
  State<AffineDemoPage> createState() => _AffineDemoPageState();
}

class _AffineDemoPageState extends State<AffineDemoPage> {
  final List<Offset> A = [
    const Offset(50, 100), const Offset(150, 100), const Offset(150, 200), const Offset(50, 200), //
  ];

  List<Offset> B = [
    // const Offset(50, 100), const Offset(150, 100), const Offset(150, 200), const Offset(50, 200), //
    const Offset(200, 200), const Offset(300, 200), const Offset(250, 300), const Offset(150, 300), //
  ];

  final colors = [Colors.red, Colors.green, Colors.blue, Colors.orange];

  @override
  void initState() {
    super.initState();

    B = XDrawBoxUtils.rotatePoints(B, XRotationUtils.degreeToRadian(-50));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            width: 500,
            color: Colors.white.withOpacity(0.7),
            child: SingleChildScrollView(
              child: Text(logText(A, B), style: const TextStyle(fontSize: 12, color: Colors.black)),
            ),
          ),
        ),
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: AffinePainter(A: A, B: B, colors: colors),
        ),
        for (int i = 0; i < B.length; i++)
          Positioned(
            left: B[i].dx - 12 / 2,
            top: B[i].dy - 12 / 2,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  B[i] = B[i] + details.delta;
                });
              },
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle),
              ),
            ),
          ),

        ElevatedButton(
          onPressed: () {
            print("aaa");
            B = A.toList();
            setState(() {});
          },
          child: Text("重置"),
        ),
      ],
    );
  }

}
