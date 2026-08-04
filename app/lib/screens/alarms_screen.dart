import 'package:flutter/material.dart';

import '../services/monitor_controller.dart';
import '../theme/app_theme.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key, required this.controller});
  final MonitorController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Alarmhistorik')),
          body: controller.alarmHistory.isEmpty
              ? const Center(child: Text('Ingen alarmer registreret', style: TextStyle(color: AppColors.mutedText)))
              : ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: controller.alarmHistory.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final alarm = controller.alarmHistory[index];
                    return ListTile(
                      leading: Icon(alarm.acknowledged ? Icons.check_circle_outline : Icons.warning_amber_rounded, color: alarm.acknowledged ? AppColors.noSignal : AppColors.alarm),
                      title: Text(alarm.name),
                      subtitle: Text(alarm.time.toLocal().toString(), style: const TextStyle(color: AppColors.mutedText)),
                      trailing: alarm.acknowledged ? const Text('Kvitteret') : FilledButton.tonal(onPressed: () => controller.acknowledge(alarm), child: const Text('Kvitter')),
                    );
                  },
                ),
        ),
      );
}
