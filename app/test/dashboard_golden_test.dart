import 'package:combine_monitor/screens/dashboard_screen.dart';
import 'package:combine_monitor/services/monitor_controller.dart';
import 'package:combine_monitor/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const generateGolden = bool.fromEnvironment('GENERATE_GOLDEN');

void main() {
  testWidgets('MF 29 XP dashboard golden at 1280x800', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = MonitorController();
    const goldenKey = ValueKey('dashboard-golden');
    await tester.pumpWidget(MaterialApp(theme: AppTheme.dark, home: RepaintBoundary(key: goldenKey, child: DashboardScreen(controller: controller))));
    await tester.pump(const Duration(milliseconds: 600));
    await expectLater(find.byKey(goldenKey), matchesGoldenFile('goldens/dashboard-v0.2.png'));
    controller.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
  }, skip: !generateGolden);
}
