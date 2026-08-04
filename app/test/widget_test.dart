import 'package:combine_monitor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app starts on the MF 29 XP dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CombineMonitorApp());
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('MASSEY FERGUSON 29 XP'), findsOneWidget);
  });
}
