import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ConnectionLines extends CustomPainter {
  const ConnectionLines({required this.leftCount, required this.rightCount});
  final int leftCount;
  final int rightCount;

  static const leftAnchors = [Offset(.455, .32), Offset(.43, .45), Offset(.43, .59), Offset(.455, .72)];
  static const rightAnchors = [Offset(.57, .34), Offset(.6, .47), Offset(.6, .61), Offset(.56, .73)];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.line..strokeWidth = 1.15..style = PaintingStyle.stroke;
    final dot = Paint()..color = AppColors.accent;
    for (var i = 0; i < leftCount; i++) {
      final start = Offset(size.width * .245, size.height * (i + .5) / leftCount);
      final anchor = leftAnchors[i.clamp(0, leftAnchors.length - 1).toInt()];
      final end = Offset(size.width * anchor.dx, size.height * anchor.dy);
      canvas.drawPath(Path()..moveTo(start.dx, start.dy)..lineTo(size.width * .32, start.dy)..lineTo(end.dx, end.dy), paint);
      canvas.drawCircle(end, 2.7, dot);
    }
    for (var i = 0; i < rightCount; i++) {
      final start = Offset(size.width * .755, size.height * (i + .5) / rightCount);
      final anchor = rightAnchors[i.clamp(0, rightAnchors.length - 1).toInt()];
      final end = Offset(size.width * anchor.dx, size.height * anchor.dy);
      canvas.drawPath(Path()..moveTo(start.dx, start.dy)..lineTo(size.width * .68, start.dy)..lineTo(end.dx, end.dy), paint);
      canvas.drawCircle(end, 2.7, dot);
    }
  }

  @override bool shouldRepaint(ConnectionLines oldDelegate) => oldDelegate.leftCount != leftCount || oldDelegate.rightCount != rightCount;
}
