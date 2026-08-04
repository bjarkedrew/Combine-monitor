class TelemetryFrame {
  const TelemetryFrame({required this.uptimeMs, required this.values});
  final int uptimeMs;
  final Map<String, double> values;
}
