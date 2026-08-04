import 'dart:async';
import 'dart:math';

import '../models/guard.dart';
import '../models/telemetry_frame.dart';
import 'telemetry_source.dart';

enum SimulatorMode { normal, lowRpm, disconnected }

class SimulatorTelemetrySource implements TelemetrySource {
  SimulatorTelemetrySource(this.guards) {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => _tick());
  }

  final List<GuardConfig> guards;
  final _output = StreamController<TelemetryFrame>.broadcast();
  final _random = Random(7500);
  late final Timer _timer;
  int _uptimeMs = 0;

  SimulatorMode mode = SimulatorMode.normal;
  String lowGuardId = 'threshingDrum';
  bool unloadingAuger = false;

  @override
  Stream<TelemetryFrame> get frames => _output.stream;

  @override
  bool get connected => mode != SimulatorMode.disconnected;

  void _tick() {
    _uptimeMs += 500;
    if (!connected) return;
    final values = <String, double>{};
    for (final guard in guards) {
      if (guard.id == 'unloadingAuger') {
        values[guard.id] = unloadingAuger ? 1 : 0;
        continue;
      }
      final center = guard.minRpm + (guard.maxRpm - guard.minRpm) * .58;
      values[guard.id] = mode == SimulatorMode.lowRpm && guard.id == lowGuardId
          ? guard.minRpm * .72
          : center + (_random.nextDouble() - .5) * max(10, center * .05);
    }
    _output.add(TelemetryFrame(uptimeMs: _uptimeMs, values: values));
  }

  @override
  void dispose() {
    _timer.cancel();
    _output.close();
  }
}
