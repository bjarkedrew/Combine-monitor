import 'package:flutter/material.dart';

import '../models/guard.dart';
import '../theme/app_theme.dart';

class GuardConnection {
  const GuardConnection(this.id, this.status);
  final String id;
  final GuardStatus status;
}

class ConnectionLines extends CustomPainter {
  const ConnectionLines({required this.left, required this.right});
  final List<GuardConnection> left;
  final List<GuardConnection> right;

  // Normalized dashboard coordinates, mirrored in sensor_points.json.
  static const anchors = <String, Offset>{
    'threshingDrum': Offset(.430, .575),
    'strawWalkers': Offset(.590, .505),
    'fan': Offset(.475, .690),
    'chopper': Offset(.665, .665),
    'cleanGrainElevator': Offset(.565, .420),
    'returnsElevator': Offset(.610, .545),
    'cleaningShoe': Offset(.555, .640),
    'unloadingAuger': Offset(.665, .310),
  };

  Color _color(GuardStatus status) => switch (status) {
        GuardStatus.normal => AppColors.accent,
        GuardStatus.warning => AppColors.warning,
        GuardStatus.alarm => AppColors.alarm,
        GuardStatus.noSignal => AppColors.noSignal,
      };

  @override
  void paint(Canvas canvas, Size size) {
    _paintRail(canvas, size, left, true);
    _paintRail(canvas, size, right, false);
  }

  void _paintRail(Canvas canvas, Size size, List<GuardConnection> items, bool isLeft) {
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final anchor = anchors[item.id] ?? const Offset(.5, .5);
      final start = Offset(size.width * (isLeft ? .245 : .755), size.height * (i + .5) / items.length);
      final elbow = Offset(size.width * (isLeft ? .325 : .675), start.dy);
      final end = Offset(size.width * anchor.dx, size.height * anchor.dy);
      final color = _color(item.status);
      final paint = Paint()..color = color.withValues(alpha: .72)..strokeWidth = 1.25..style = PaintingStyle.stroke;
      canvas.drawPath(Path()..moveTo(start.dx, start.dy)..lineTo(elbow.dx, elbow.dy)..lineTo(end.dx, end.dy), paint);
      canvas.drawCircle(end, 4.5, Paint()..color = AppColors.background);
      canvas.drawCircle(end, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(ConnectionLines oldDelegate) => oldDelegate.left != left || oldDelegate.right != right;
}
