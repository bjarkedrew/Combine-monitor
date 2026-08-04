class AlarmEvent {
  AlarmEvent({required this.guardId, required this.name, required this.time});
  final String guardId;
  final String name;
  final DateTime time;
  bool acknowledged = false;
}
