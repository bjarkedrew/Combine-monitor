import 'package:flutter/material.dart';

import '../models/guard.dart';
import '../theme/app_theme.dart';

class GuardDetailsSheet extends StatelessWidget {
  const GuardDetailsSheet({super.key, required this.guard, required this.status, required this.value});
  final GuardConfig guard;
  final GuardStatus status;
  final double? value;

  String get statusText => switch (status) { GuardStatus.normal => 'Normal', GuardStatus.warning => 'Nær alarmgrænse', GuardStatus.alarm => 'Alarm', GuardStatus.noSignal => 'Intet signal' };
  Color get statusColor => switch (status) { GuardStatus.normal => AppColors.normal, GuardStatus.warning => AppColors.warning, GuardStatus.alarm => AppColors.alarm, GuardStatus.noSignal => AppColors.noSignal };

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 18),
            Row(children: [Expanded(child: Text(guard.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(value == null ? '—' : value!.round().toString(), style: TextStyle(color: statusColor, fontSize: 42, height: 1, fontWeight: FontWeight.w700)), if (guard.signalType != 'switch') const Padding(padding: EdgeInsets.only(left: 7, bottom: 4), child: Text('RPM', style: TextStyle(color: AppColors.mutedText))), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: statusColor.withValues(alpha: .12), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withValues(alpha: .6))), child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)))]),
            const SizedBox(height: 20),
            Wrap(spacing: 10, runSpacing: 10, children: [
              _Detail(label: 'Minimum', value: '${guard.minRpm.round()} RPM'),
              _Detail(label: 'Maksimum', value: '${guard.maxRpm.round()} RPM'),
              _Detail(label: 'Gul grænse', value: '${guard.warningRpm.round()} RPM'),
              _Detail(label: 'Alarmforsinkelse', value: '${guard.alarmDelaySeconds} sek.'),
              _Detail(label: 'ESP32-indgang', value: '${guard.input}'),
              _Detail(label: 'Pulser/omdr.', value: guard.pulsesPerRevolution.toStringAsFixed(1)),
            ]),
          ]),
        ),
      );
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});
  final String label;
  final String value;
  @override Widget build(BuildContext context) => Container(width: 150, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.panelRaised, borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 11)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600))]));
}
