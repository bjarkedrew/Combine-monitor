import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/dashboard_screen.dart';
import 'services/monitor_controller.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const CombineMonitorApp());
}

class CombineMonitorApp extends StatefulWidget {
  const CombineMonitorApp({super.key});
  @override State<CombineMonitorApp> createState() => _CombineMonitorAppState();
}

class _CombineMonitorAppState extends State<CombineMonitorApp> {
  late final MonitorController controller;
  @override void initState() { super.initState(); controller = MonitorController(); }
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Combine Monitor', theme: AppTheme.dark, home: DashboardScreen(controller: controller));
}
