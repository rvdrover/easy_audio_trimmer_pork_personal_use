import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class FixedBarViewer extends StatelessWidget {
  final File audioFile;
  final int audioDuration; // in milliseconds
  final double barHeight;
  final double barWeight; // total width of the waveform view
  final BoxFit fit;

  final Color? barColor;
  final Color? backgroundColor;

  /// For showing the bars generated from the audio,
  /// like a frame-by-frame preview
  const FixedBarViewer({
    super.key,
    required this.audioFile,
    required this.audioDuration,
    required this.barHeight,
    required this.barWeight,
    required this.fit,
    this.backgroundColor,
    this.barColor,
  });

  /// How many milliseconds each bar represents
  int get millisecondsPerBar => 100;

  int get barCount => (audioDuration / millisecondsPerBar).ceil();

  Future<List<int>> generateBars(int count) async {
    final bars = <int>[];
    final r = Random();
    for (int i = 0; i < count; i++) {
      final maxHeight = max(1, barHeight.toInt() - 1);
      bars.add(r.nextInt(maxHeight));
    }
    return bars;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = barWeight == 0 ? constraints.maxWidth : barWeight;
      final count = barCount;
      final barWidth = totalWidth / count;

      return FutureBuilder<List<int>>(
        future: generateBars(count),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bars = snapshot.data!;
            return Container(
              color: backgroundColor ?? Colors.white,
              height: barHeight,
              width: totalWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: bars.map((height) {
                  return SizedBox(
                    width: barWidth,
                    child: Container(
                      height: height.toDouble(),
                      color: barColor ?? Colors.black,
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return Container(
              color: backgroundColor ?? Colors.grey[900],
              height: barHeight,
              width: totalWidth,
            );
          }
        },
      );
    });
  }
}
