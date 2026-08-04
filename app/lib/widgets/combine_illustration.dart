import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CombineIllustration extends StatelessWidget {
  const CombineIllustration({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Stiliseret Massey Ferguson 29 XP mejetærsker',
        child: const AspectRatio(aspectRatio: 1.55, child: CustomPaint(painter: Mf29XpPainter())),
      );
}

class Mf29XpPainter extends CustomPainter {
  const Mf29XpPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 620;
    canvas.save();
    canvas.scale(scale, scale);
    final height = size.height / scale;
    canvas.translate(0, (height - 400) / 2);

    final outline = Paint()..color = const Color(0xff252b2d)..style = PaintingStyle.stroke..strokeWidth = 5..strokeJoin = StrokeJoin.round;
    final red = Paint()..color = AppColors.mfRed;
    final darkRed = Paint()..color = AppColors.mfRedDark;
    final cream = Paint()..color = AppColors.grainTank;
    final black = Paint()..color = const Color(0xff111516);
    final glass = Paint()..color = const Color(0xff27353a);
    final steel = Paint()..color = const Color(0xff6c7578);
    final accent = Paint()..color = AppColors.accent;

    // Unloading auger, raised toward the rear.
    final auger = Path()..moveTo(386, 90)..lineTo(558, 28)..lineTo(568, 39)..lineTo(406, 116)..close();
    canvas.drawPath(auger, darkRed); canvas.drawPath(auger, outline);
    canvas.drawCircle(const Offset(564, 34), 9, red);

    // Light upper grain tank characteristic of this MF generation.
    final tank = Path()..moveTo(213, 74)..lineTo(389, 68)..lineTo(429, 162)..lineTo(191, 162)..close();
    canvas.drawPath(tank, cream); canvas.drawPath(tank, outline);
    canvas.drawLine(const Offset(230, 91), const Offset(397, 87), Paint()..color = const Color(0xffb9b5aa)..strokeWidth = 3);

    // Main red body and rear engine housing.
    final body = Path()..moveTo(129, 170)..lineTo(416, 150)..lineTo(495, 213)..lineTo(458, 300)..lineTo(120, 300)..lineTo(89, 249)..close();
    canvas.drawPath(body, red); canvas.drawPath(body, outline);
    final rear = Path()..moveTo(405, 156)..lineTo(493, 210)..lineTo(461, 249)..lineTo(403, 235)..close();
    canvas.drawPath(rear, darkRed);
    canvas.drawLine(const Offset(406, 177), const Offset(474, 217), Paint()..color = const Color(0xffd75558)..strokeWidth = 3);

    // Dark, forward-set cab with slanted windscreen.
    final cab = Path()..moveTo(105, 92)..lineTo(191, 86)..lineTo(222, 178)..lineTo(106, 190)..close();
    canvas.drawPath(cab, black); canvas.drawPath(cab, outline);
    final windscreen = Path()..moveTo(119, 104)..lineTo(178, 99)..lineTo(199, 160)..lineTo(121, 169)..close();
    canvas.drawPath(windscreen, glass);
    canvas.drawLine(const Offset(165, 101), const Offset(181, 163), Paint()..color = const Color(0xff718287)..strokeWidth = 3);
    canvas.drawRect(const Rect.fromLTWH(188, 106, 18, 57), glass);

    // MF stripe and model identification.
    canvas.drawRect(const Rect.fromLTWH(221, 183, 195, 18), cream);
    canvas.drawRect(const Rect.fromLTWH(221, 202, 195, 6), accent);
    final modelPainter = TextPainter(text: const TextSpan(text: 'MASSEY FERGUSON  29 XP', style: TextStyle(color: Color(0xff321012), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .4)), textDirection: TextDirection.ltr)..layout();
    modelPainter.paint(canvas, const Offset(230, 185));

    // Axles and wheels: large front, smaller rear.
    canvas.drawRect(const Rect.fromLTWH(146, 280, 320, 18), black);
    _wheel(canvas, const Offset(188, 305), 72, black, steel);
    _wheel(canvas, const Offset(444, 308), 48, black, steel);

    // Feeder house and broad header.
    final feeder = Path()..moveTo(115, 225)..lineTo(51, 278)..lineTo(142, 292)..lineTo(173, 254)..close();
    canvas.drawPath(feeder, darkRed); canvas.drawPath(feeder, outline);
    final header = Path()..moveTo(18, 281)..lineTo(155, 291)..lineTo(142, 333)..lineTo(10, 324)..close();
    canvas.drawPath(header, red); canvas.drawPath(header, outline);
    canvas.drawLine(const Offset(15, 316), const Offset(145, 324), Paint()..color = AppColors.accent..strokeWidth = 5);
    for (var x = 18.0; x < 146; x += 18) {
      canvas.drawLine(Offset(x, 319), Offset(x - 5, 342), Paint()..color = steel.color..strokeWidth = 3);
    }
    canvas.drawCircle(const Offset(79, 300), 38, Paint()..color = Colors.transparent..style = PaintingStyle.stroke..strokeWidth = 3);
    for (var a = 0; a < 8; a++) {
      final angle = a * .785;
      canvas.drawLine(const Offset(79, 300), Offset(79 + 35 * math.cos(angle), 300 + 35 * math.sin(angle)), Paint()..color = const Color(0xff545e61)..strokeWidth = 2);
    }

    // Small technical details.
    canvas.drawRect(const Rect.fromLTWH(435, 219, 42, 8), steel);
    canvas.drawCircle(const Offset(113, 213), 6, accent);
    canvas.drawLine(const Offset(335, 155), const Offset(351, 79), outline);
    canvas.restore();
  }

  void _wheel(Canvas canvas, Offset center, double radius, Paint tire, Paint hub) {
    canvas.drawCircle(center, radius, tire);
    canvas.drawCircle(center, radius * .66, Paint()..color = const Color(0xff282e30));
    canvas.drawCircle(center, radius * .34, hub);
    canvas.drawCircle(center, radius * .13, Paint()..color = const Color(0xff303638));
    final tread = Paint()..color = const Color(0xff41484a)..strokeWidth = 5;
    for (var i = 0; i < 12; i++) {
      final angle = i * .524;
      canvas.drawLine(Offset(center.dx + radius * .76 * math.cos(angle), center.dy + radius * .76 * math.sin(angle)), Offset(center.dx + radius * .96 * math.cos(angle), center.dy + radius * .96 * math.sin(angle)), tread);
    }
  }

  @override bool shouldRepaint(Mf29XpPainter oldDelegate) => false;
}
