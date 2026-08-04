# Preliminary interface guidance

This is prototype guidance, not a finished PCB.

- Convert 12 V digital and ground-switching signals through protected optocoupler or Schmitt-comparator stages with hysteresis.
- Condition Hall/open-collector sensors with appropriate protected pull-ups.
- Feed inductive sensors through a variable-reluctance conditioner or protected zero-crossing comparator, never directly to an ESP32.
- Scale, clamp, and filter analog temperature/pressure sensors for a suitable ADC/reference.
- Use a fused automotive buck supply, load-dump-rated TVS, reverse-polarity protection, input filtering, and decoupling.
- Keep buzzer/load returns away from sensor grounds and use locking, strain-relieved connectors.

Bench-test representative noise and voltage before machine installation.
