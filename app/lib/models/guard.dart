enum GuardSide { left, right }

enum GuardStatus { normal, warning, alarm, noSignal }

class GuardConfig {
  GuardConfig({
    required this.id,
    required this.side,
    required this.name,
    required this.input,
    required this.minRpm,
    required this.maxRpm,
    required this.warningRpm,
    this.signalType = 'pulse',
    this.pulsesPerRevolution = 1,
    this.alarmDelaySeconds = 3,
    this.buzzerEnabled = true,
    this.active = true,
  });

  final String id;
  final GuardSide side;
  String name;
  String signalType;
  int input;
  double minRpm;
  double maxRpm;
  double warningRpm;
  double pulsesPerRevolution;
  int alarmDelaySeconds;
  bool buzzerEnabled;
  bool active;

  Map<String, dynamic> toJson() => {
        'id': id,
        'side': side.name,
        'name': name,
        'signal': signalType,
        'input': input,
        'min': minRpm,
        'max': maxRpm,
        'warning': warningRpm,
        'ppr': pulsesPerRevolution,
        'delay': alarmDelaySeconds,
        'buzzer': buzzerEnabled,
        'active': active,
      };

  factory GuardConfig.fromJson(Map<String, dynamic> json) => GuardConfig(
        id: json['id'] as String,
        side: json['side'] == 'right' ? GuardSide.right : GuardSide.left,
        name: json['name'] as String,
        signalType: json['signal'] as String,
        input: (json['input'] as num).toInt(),
        minRpm: (json['min'] as num).toDouble(),
        maxRpm: (json['max'] as num).toDouble(),
        warningRpm: (json['warning'] as num).toDouble(),
        pulsesPerRevolution: (json['ppr'] as num).toDouble(),
        alarmDelaySeconds: (json['delay'] as num).toInt(),
        buzzerEnabled: json['buzzer'] as bool,
        active: json['active'] as bool,
      );

  static List<GuardConfig> masseyFerguson29XpDefaults() => [
        GuardConfig(id: 'threshingDrum', side: GuardSide.left, name: 'Tærskecylinder', input: 0, minRpm: 400, maxRpm: 1200, warningRpm: 450),
        GuardConfig(id: 'strawWalkers', side: GuardSide.left, name: 'Halmrystere', input: 1, minRpm: 160, maxRpm: 320, warningRpm: 180, alarmDelaySeconds: 4),
        GuardConfig(id: 'fan', side: GuardSide.left, name: 'Underblæser', input: 2, minRpm: 600, maxRpm: 1100, warningRpm: 650),
        GuardConfig(id: 'chopper', side: GuardSide.left, name: 'Snitter', input: 3, minRpm: 2400, maxRpm: 3400, warningRpm: 2550, alarmDelaySeconds: 2),
        GuardConfig(id: 'cleanGrainElevator', side: GuardSide.right, name: 'Kornelevator', input: 4, minRpm: 330, maxRpm: 520, warningRpm: 360),
        GuardConfig(id: 'returnsElevator', side: GuardSide.right, name: 'Returelevator', input: 5, minRpm: 300, maxRpm: 500, warningRpm: 330),
        GuardConfig(id: 'cleaningShoe', side: GuardSide.right, name: 'Renseri/sold', input: 6, minRpm: 230, maxRpm: 360, warningRpm: 250, alarmDelaySeconds: 4),
        GuardConfig(id: 'unloadingAuger', side: GuardSide.right, name: 'Tømmesnegl', input: 7, minRpm: 1, maxRpm: 1, warningRpm: 1, signalType: 'switch', buzzerEnabled: false),
      ];
}
