# Combine Monitor

Combine Monitor is an Android-first retrofit monitor for older combine harvesters, initially the Dronningborg D7500. The landscape Flutter dashboard shows the machine, active guards, connection state, and compact navigation to settings and alarms.

> **Safety:** Never connect 12 V machine wiring directly to an ESP32. Use a protected interface with isolation or level conversion. Automotive power requires a fuse, reverse-polarity protection, TVS suppression, and filtering.

## Structure

- `app/` Flutter app and simulator
- `firmware/` PlatformIO ESP32 firmware
- `hardware/` preliminary interface guidance and BOM
- `machine_profiles/` versioned JSON configurations
- `docs/` architecture and protocol

## Simulator and APK

```sh
cd app
flutter create --platforms=android --project-name combine_monitor .
flutter pub get
flutter run
```

The app starts in simulator mode. Settings can induce low RPM, disconnect telemetry, and toggle the unloading auger. Guard configuration is stored locally.

Build locally with `flutter build apk --release`. On GitHub, open the successful **Build Android APK** run and download the `combine-monitor-apk` artifact, which contains `app-release.apk`.

## Firmware

Run `pio run` in `firmware/`; use `pio run --target upload` to flash. Demo telemetry is enabled by default. Disable `DEMO_MODE` only after protected sensor interfaces are connected.

## Limitations

v0.1 is simulator-first. Live WebSocket transport is prepared by the shared protocol but not yet enabled in the app. The hardware notes are not a production schematic. Calibration must be verified on the actual D7500. Camera, GPS, hectare/yield/moisture sensing, cloud features, and advanced animation are intentionally out of scope.
