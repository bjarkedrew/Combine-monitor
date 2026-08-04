import 'package:flutter/material.dart';

import '../models/guard.dart';
import '../services/monitor_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/combine_illustration.dart';
import '../widgets/connection_lines.dart';
import '../widgets/guard_card.dart';
import '../widgets/guard_details_sheet.dart';
import 'alarms_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.controller});
  final MonitorController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final left = controller.guardsOn(GuardSide.left);
          final right = controller.guardsOn(GuardSide.right);
          return Scaffold(
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                final compact = constraints.maxWidth < 1100 || constraints.maxHeight < 680;
                final outerPadding = compact ? 12.0 : 20.0;
                return Padding(
                  padding: EdgeInsets.all(outerPadding),
                  child: Column(children: [
                    _DashboardHeader(controller: controller, compact: compact),
                    SizedBox(height: compact ? 8 : 14),
                    Expanded(
                      child: Stack(children: [
                        Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: ConnectionLines(leftCount: left.length, rightCount: right.length)))),
                        Row(children: [
                          Expanded(flex: compact ? 28 : 25, child: _GuardRail(guards: left, controller: controller)),
                          Expanded(flex: compact ? 44 : 50, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: Center(child: CombineIllustration()))),
                          Expanded(flex: compact ? 28 : 25, child: _GuardRail(guards: right, controller: controller)),
                        ]),
                      ]),
                    ),
                  ]),
                );
              }),
            ),
          );
        },
      );
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.controller, required this.compact});
  final MonitorController controller;
  final bool compact;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: compact ? 42 : 48,
        child: Row(children: [
          Container(width: 4, height: 28, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 11),
          Text('MASSEY FERGUSON 29 XP', key: const ValueKey('machine-title'), style: TextStyle(color: AppColors.text, fontSize: compact ? 16 : 19, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
          const Spacer(),
          Container(
            key: const ValueKey('connection-status'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.line)),
            child: Row(children: [Icon(controller.connected ? Icons.wifi_rounded : Icons.wifi_off_rounded, size: 16, color: controller.connected ? AppColors.normal : AppColors.alarm), const SizedBox(width: 6), Text(controller.connected ? 'Forbundet' : 'Ingen forbindelse', style: const TextStyle(color: AppColors.mutedText, fontSize: 12))]),
          ),
          const SizedBox(width: 6),
          IconButton(tooltip: 'Alarmer', visualDensity: VisualDensity.compact, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlarmsScreen(controller: controller))), icon: const Icon(Icons.notifications_none_rounded, color: AppColors.mutedText)),
          IconButton(tooltip: 'Opsætning', visualDensity: VisualDensity.compact, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(controller: controller))), icon: const Icon(Icons.tune_rounded, color: AppColors.mutedText)),
        ]),
      );
}

class _GuardRail extends StatelessWidget {
  const _GuardRail({required this.guards, required this.controller});
  final List<GuardConfig> guards;
  final MonitorController controller;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: guards.map((guard) => GuardCard(
          guard: guard,
          status: controller.statusFor(guard),
          value: controller.frame?.values[guard.id],
          onTap: () => showModalBottomSheet<void>(context: context, backgroundColor: AppColors.panel, showDragHandle: false, isScrollControlled: true, builder: (_) => GuardDetailsSheet(guard: guard, status: controller.statusFor(guard), value: controller.frame?.values[guard.id])),
        )).toList(growable: false),
      );
}
