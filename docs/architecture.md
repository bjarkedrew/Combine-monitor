# Architecture

The UI consumes a `TelemetrySource`. `SimulatorTelemetrySource` emits immutable `TelemetryFrame` values; a later WebSocket source can emit the same type without changing screens. `MonitorController` owns current values, connection health, delayed alarm timers, acknowledgements, history, and JSON preferences.

Firmware interrupt handlers count edges. The main loop snapshots counters atomically, calculates RPM on a fixed interval without blocking, and broadcasts protocol-v1 JSON.
