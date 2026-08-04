import '../models/telemetry_frame.dart';

abstract class TelemetrySource {
  Stream<TelemetryFrame> get frames;
  bool get connected;
  void dispose();
}
