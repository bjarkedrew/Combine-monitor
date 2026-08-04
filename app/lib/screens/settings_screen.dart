import 'package:flutter/material.dart';

import '../services/monitor_controller.dart';
import '../services/simulator_telemetry_source.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});
  final MonitorController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Opsætning'), actions: [TextButton.icon(onPressed: controller.save, icon: const Icon(Icons.save_outlined), label: const Text('Gem'))]),
          body: ListView(padding: const EdgeInsets.all(18), children: [
            SegmentedButton<SimulatorMode>(
              segments: const [ButtonSegment(value: SimulatorMode.normal, label: Text('Normal')), ButtonSegment(value: SimulatorMode.lowRpm, label: Text('Lav RPM')), ButtonSegment(value: SimulatorMode.disconnected, label: Text('Afbryd'))],
              selected: {controller.simulator.mode},
              onSelectionChanged: (selection) => controller.setSimulatorMode(selection.first),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: controller.simulator.lowGuardId,
              decoration: const InputDecoration(labelText: 'Vagt med lav RPM'),
              items: controller.guards.where((guard) => guard.id != 'unloadingAuger').map((guard) => DropdownMenuItem(value: guard.id, child: Text(guard.name))).toList(),
              onChanged: (value) { if (value != null) controller.setLowGuard(value); },
            ),
            SwitchListTile(title: const Text('Tømmesnegl aktiv'), value: controller.simulator.unloadingAuger, onChanged: controller.setUnloadingAuger),
            const Divider(height: 30),
            ...controller.guards.map((guard) => Card(
                  child: ExpansionTile(
                    title: Text(guard.name),
                    leading: Switch(value: guard.active, onChanged: (value) { guard.active = value; controller.save(); }),
                    children: [Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(spacing: 12, runSpacing: 12, children: [
                        _textField('Navn', guard.name, (value) => guard.name = value),
                        _numberField('ESP32-indgang', guard.input.toDouble(), (value) => guard.input = value.round()),
                        _numberField('Pulser/omdr.', guard.pulsesPerRevolution, (value) => guard.pulsesPerRevolution = value),
                        _numberField('Minimum RPM', guard.minRpm, (value) => guard.minRpm = value),
                        _numberField('Maksimum RPM', guard.maxRpm, (value) => guard.maxRpm = value),
                        _numberField('Gul grænse', guard.warningRpm, (value) => guard.warningRpm = value),
                        _numberField('Alarmforsinkelse', guard.alarmDelaySeconds.toDouble(), (value) => guard.alarmDelaySeconds = value.round()),
                        SizedBox(width: 220, child: SwitchListTile(title: const Text('Summer'), value: guard.buzzerEnabled, onChanged: (value) => guard.buzzerEnabled = value)),
                      ]),
                    )],
                  ),
                )),
          ]),
        ),
      );

  Widget _textField(String label, String value, ValueChanged<String> changed) => SizedBox(width: 220, child: TextFormField(initialValue: value, decoration: InputDecoration(labelText: label), onChanged: changed));
  Widget _numberField(String label, double value, ValueChanged<double> changed) => SizedBox(width: 180, child: TextFormField(initialValue: '${value.round()}', keyboardType: TextInputType.number, decoration: InputDecoration(labelText: label), onChanged: (input) { final parsed = double.tryParse(input); if (parsed != null) changed(parsed); }));
}
