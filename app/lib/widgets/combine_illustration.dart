import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Deterministic Flutter rendering of the seven SVG layers in
/// assets/machines/mf29xp. All coordinates use the shared 720 x 420 viewBox.
class CombineIllustration extends StatelessWidget {
  const CombineIllustration({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Stiliseret Massey Ferguson 29 XP mejetærsker',
        image: true,
        child: const AspectRatio(
          aspectRatio: 720 / 420,
          child: CustomPaint(painter: Mf29XpLayerPainter()),
        ),
      );
}

class Mf29XpLayerPainter extends CustomPainter {
  const Mf29XpLayerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 720;
    canvas.save();
    canvas.scale(scale, scale);
    canvas.translate(0, (size.height / scale - 420) / 2);
    _body(canvas);
    _tank(canvas);
    _cab(canvas);
    _auger(canvas);
    _header(canvas);
    _wheels(canvas);
    _details(canvas);
    canvas.restore();
  }

  Paint get _outline => Paint()
    ..color = const Color(0xff272d2f)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..strokeJoin = StrokeJoin.round;

  void _body(Canvas canvas) {
    final body = Path()..moveTo(202, 168)..lineTo(526, 168)..lineTo(604, 226)..lineTo(579, 315)..lineTo(190, 315)..lineTo(156, 241)..close();
    canvas.drawPath(body, Paint()..color = AppColors.mfRed); canvas.drawPath(body, _outline);
    final rear = Path()..moveTo(507, 180)..lineTo(550, 180)..lineTo(604, 226)..lineTo(579, 315)..lineTo(522, 315)..lineTo(522, 236)..close();
    canvas.drawPath(rear, Paint()..color = AppColors.mfRedDark); canvas.drawPath(rear, _outline);
    final feeder = Path()..moveTo(194, 214)..lineTo(142, 214)..lineTo(77, 298)..lineTo(197, 314)..lineTo(245, 237)..close();
    canvas.drawPath(feeder, Paint()..color = const Color(0xff951f27)); canvas.drawPath(feeder, _outline);
  }

  void _tank(Canvas canvas) {
    final tank = Path()..moveTo(279, 72)..lineTo(500, 72)..lineTo(531, 177)..lineTo(266, 177)..lineTo(256, 124)..close();
    canvas.drawPath(tank, Paint()..color = AppColors.grainTank); canvas.drawPath(tank, _outline);
    canvas.drawLine(const Offset(285, 96), const Offset(501, 96), Paint()..color = const Color(0xffc9c4b5)..strokeWidth = 9);
    canvas.drawLine(const Offset(431, 77), const Offset(413, 175), _outline);
  }

  void _cab(Canvas canvas) {
    final cab = Path()..moveTo(164, 74)..lineTo(266, 74)..lineTo(276, 216)..lineTo(157, 224)..close();
    canvas.drawPath(cab, Paint()..color = const Color(0xff111516)); canvas.drawPath(cab, _outline);
    final glass = Path()..moveTo(176, 89)..lineTo(248, 89)..lineTo(252, 194)..lineTo(174, 201)..close();
    canvas.drawPath(glass, Paint()..color = const Color(0xff2a3a3f));
    canvas.drawLine(const Offset(211, 90), const Offset(214, 198), Paint()..color = const Color(0xff718287)..strokeWidth = 3);
  }

  void _auger(Canvas canvas) {
    final pipe = Path()..moveTo(492, 94)..lineTo(677, 94)..lineTo(677, 111)..lineTo(492, 111)..close();
    canvas.drawPath(pipe, Paint()..color = AppColors.mfRedDark); canvas.drawPath(pipe, _outline);
    canvas.drawRect(const Rect.fromLTWH(671, 93, 25, 28), Paint()..color = AppColors.mfRed); canvas.drawRect(const Rect.fromLTWH(671, 93, 25, 28), _outline);
  }

  void _header(Canvas canvas) {
    final header = Path()..moveTo(25, 295)..lineTo(197, 306)..lineTo(185, 361)..lineTo(14, 348)..close();
    canvas.drawPath(header, Paint()..color = AppColors.mfRed); canvas.drawPath(header, _outline);
    canvas.drawLine(const Offset(22, 343), const Offset(188, 356), Paint()..color = AppColors.accent..strokeWidth = 5);
    for (var x = 22.0; x <= 172; x += 25) { canvas.drawLine(Offset(x, 337), Offset(x - 7, 377), Paint()..color = const Color(0xff737d80)..strokeWidth = 3); }
    canvas.drawCircle(const Offset(101, 321), 39, Paint()..color = Colors.transparent..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xff596467));
  }

  void _wheels(Canvas canvas) {
    _wheel(canvas, const Offset(260, 322), 82, 25);
    _wheel(canvas, const Offset(544, 327), 49, 14);
  }

  void _wheel(Canvas canvas, Offset center, double radius, double hub) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xff111516));
    canvas.drawCircle(center, radius * .66, Paint()..color = const Color(0xff303638));
    canvas.drawCircle(center, hub, Paint()..color = const Color(0xff7b8588));
    canvas.drawCircle(center, hub * .36, Paint()..color = const Color(0xff303638));
    canvas.drawCircle(center, radius, _outline);
  }

  void _details(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(283, 191, 218, 22), Paint()..color = AppColors.grainTank);
    canvas.drawRect(const Rect.fromLTWH(283, 214, 218, 5), Paint()..color = AppColors.accent);
    final label = TextPainter(text: const TextSpan(text: 'MASSEY FERGUSON  29 XP', style: TextStyle(color: Color(0xff351013), fontSize: 12, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout();
    label.paint(canvas, const Offset(297, 195));
    canvas.drawCircle(const Offset(177, 241), 6, Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(Mf29XpLayerPainter oldDelegate) => false;
}
