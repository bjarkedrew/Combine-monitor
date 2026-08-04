import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Layered MF 29 XP digital twin. Each SVG shares a 720 x 420 viewBox so parts
/// can later be highlighted or animated independently.
class CombineIllustration extends StatelessWidget {
  const CombineIllustration({super.key});

  static const _layers = <String>[
    'body.svg',
    'grain_tank.svg',
    'cab.svg',
    'unloading_auger.svg',
    'header.svg',
    'wheels.svg',
    'details.svg',
  ];

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Stiliseret Massey Ferguson 29 XP mejetærsker',
        image: true,
        child: AspectRatio(
          aspectRatio: 720 / 420,
          child: Stack(
            fit: StackFit.expand,
            children: _layers
                .map((name) => SvgPicture.asset(
                      'assets/machines/mf29xp/$name',
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ))
                .toList(growable: false),
          ),
        ),
      );
}
