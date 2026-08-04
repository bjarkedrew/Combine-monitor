import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../models/guard.dart';
import '../theme/app_theme.dart';

class GuardCard extends StatelessWidget {
  const GuardCard({super.key, required this.guard, required this.status, required this.value, required this.onTap});

  final GuardConfig guard;
  final GuardStatus status;
  final double? value;
  final VoidCallback onTap;

  Color get statusColor => switch (status) {
        GuardStatus.normal => AppColors.normal,
        GuardStatus.warning => AppColors.warning,
        GuardStatus.alarm => AppColors.alarm,
        GuardStatus.noSignal => AppColors.noSignal,
      };

  @override
  Widget build(BuildContext context) {
    final isSwitch = guard.signalType == 'switch';
    final valueText = isSwitch ? (value == 1 ? 'AKTIV' : 'STOPPET') : (value == null ? '—' : value!.round().toString());
    return Semantics(
      button: true,
      label: '${guard.name}, $valueText, ${status.name}',
      child: Material(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          key: ValueKey('guard-${guard.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72, maxHeight: 92),
            padding: const EdgeInsets.fromLTRB(14, 11, 12, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: .7), width: 1),
            ),
            child: Row(children: [
              Container(width: 4, height: 34, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 11),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(guard.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Flexible(child: Text(valueText, maxLines: 1, style: TextStyle(color: statusColor, fontSize: isSwitch ? 20 : 27, height: 1, fontWeight: FontWeight.w700, fontFeatures: const [FontFeature.tabularFigures()]))),
                    if (!isSwitch) const Padding(padding: EdgeInsets.only(left: 5, bottom: 2), child: Text('RPM', style: TextStyle(color: AppColors.mutedText, fontSize: 11, letterSpacing: .7))),
                  ]),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText, size: 18),
            ]),
          ),
        ),
      ),
    );
  }
}
