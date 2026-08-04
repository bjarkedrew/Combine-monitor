# Protocol v1

- Wi-Fi: `CombineMonitor`
- Password: `combine7500`
- WebSocket: `ws://192.168.4.1:81`

```json
{"protocol":1,"deviceId":"CM-001","uptimeMs":123456,"inputs":{"threshingDrum":865,"strawWalkers":215,"fan":780,"chopper":2950,"cleanGrainElevator":425,"returnsElevator":370,"cleaningShoe":285,"unloadingAuger":true}}
```

Reject unsupported protocol versions, treat frames older than three seconds as disconnected, ignore unknown keys, and render missing configured inputs as no signal.
