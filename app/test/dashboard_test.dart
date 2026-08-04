import 'package:combine_monitor/main.dart';
import 'package:combine_monitor/models/guard.dart';
import 'package:combine_monitor/screens/dashboard_screen.dart';
import 'package:combine_monitor/services/monitor_controller.dart';
import 'package:combine_monitor/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final size in const [Size(960, 600), Size(1280, 800), Size(1920, 1200)]) {
    testWidgets('dashboard fits ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CombineMonitorApp());
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('MASSEY FERGUSON 29 XP'), findsOneWidget);
      expect(find.text('Tærskecylinder'), findsOneWidget);
      expect(find.text('Tømmesnegl'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('disabled guards are hidden and details stay on dashboard', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final guards = GuardConfig.masseyFerguson29XpDefaults();
    guards.firstWhere((guard) => guard.id == 'chopper').active = false;
    final controller = MonitorController(initialGuards: guards);
    await tester.pumpWidget(MaterialApp(theme: AppTheme.dark, home: DashboardScreen(controller: controller)));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Snitter'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('guard-threshingDrum')));
    await tester.pumpAndSettle();
    expect(find.text('Minimum'), findsOneWidget);
    expect(find.text('Alarmforsinkelse'), findsOneWidget);
    expect(find.byType(DashboardScreen), findsOneWidget);
    controller.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
