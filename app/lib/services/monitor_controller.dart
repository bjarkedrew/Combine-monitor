import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alarm_event.dart';
import '../models/guard.dart';
import '../models/telemetry_frame.dart';
import 'simulator_telemetry_source.dart';

class MonitorController extends ChangeNotifier {
  MonitorController({List<GuardConfig>? initialGuards}) : guards = initialGuards ?? GuardConfig.masseyFerguson29XpDefaults() {
    simulator = SimulatorTelemetrySource(guards);
    _subscription = simulator.frames.listen(_receive);
    _connectionClock = Timer.periodic(const Duration(seconds: 1), (_) => notifyListeners());
    _load();
  }

  final List<GuardConfig> guards;
  late final SimulatorTelemetrySource simulator;
  late final StreamSubscription<TelemetryFrame> _subscription;
  late final Timer _connectionClock;
  final Map<String, DateTime> _belowSince = {};
  final Set<String> _activeAlarmIds = {};
  final List<AlarmEvent> alarmHistory = [];

  TelemetryFrame? frame;
  DateTime? _lastReceivedAt;

  bool get connected => simulator.connected && _lastReceivedAt != null && DateTime.now().difference(_lastReceivedAt!) < const Duration(seconds: 3);
  List<GuardConfig> guardsOn(GuardSide side) => guards.where((guard) => guard.active && guard.side == side).toList(growable: false);

  void _receive(TelemetryFrame value) {
    frame = value;
    _lastReceivedAt = DateTime.now();
    _evaluateAlarms();
    notifyListeners();
  }

  void _evaluateAlarms() {
    final now = DateTime.now();
    for (final guard in guards.where((guard) => guard.active && guard.id != 'unloadingAuger')) {
      final rpm = frame?.values[guard.id];
      if (rpm != null && rpm < guard.minRpm) {
        _belowSince.putIfAbsent(guard.id, () => now);
        if (now.difference(_belowSince[guard.id]!).inSeconds >= guard.alarmDelaySeconds && _activeAlarmIds.add(guard.id)) {
          alarmHistory.insert(0, AlarmEvent(guardId: guard.id, name: guard.name, time: now));
        }
      } else {
        _belowSince.remove(guard.id);
        _activeAlarmIds.remove(guard.id);
      }
    }
  }

  GuardStatus statusFor(GuardConfig guard) {
    if (!guard.active || !connected || frame?.values[guard.id] == null) return GuardStatus.noSignal;
    if (_activeAlarmIds.contains(guard.id)) return GuardStatus.alarm;
    if (guard.id != 'unloadingAuger' && frame!.values[guard.id]! < guard.warningRpm) return GuardStatus.warning;
    return GuardStatus.normal;
  }

  void setSimulatorMode(SimulatorMode mode) {
    simulator.mode = mode;
    if (mode == SimulatorMode.disconnected) {
      frame = null;
      _lastReceivedAt = null;
    }
    notifyListeners();
  }

  void setLowGuard(String id) { simulator.lowGuardId = id; notifyListeners(); }
  void setUnloadingAuger(bool value) { simulator.unloadingAuger = value; notifyListeners(); }
  void acknowledge(AlarmEvent event) { event.acknowledged = true; notifyListeners(); }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('guards.v1', jsonEncode(guards.map((guard) => guard.toJson()).toList()));
    notifyListeners();
  }

  Future<void> _load() async {
    final raw = (await SharedPreferences.getInstance()).getString('guards.v1');
    if (raw == null) return;
    try {
      final loaded = (jsonDecode(raw) as List).map((value) => GuardConfig.fromJson(value as Map<String, dynamic>));
      guards..clear()..addAll(loaded);
      notifyListeners();
    } on FormatException {
      // Keep the safe machine defaults if local data is malformed.
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _connectionClock.cancel();
    simulator.dispose();
    super.dispose();
  }
}
