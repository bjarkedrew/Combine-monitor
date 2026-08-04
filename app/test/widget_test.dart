import 'package:combine_monitor/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main(){testWidgets('simple dashboard contains machine and guards',(tester)async{SharedPreferences.setMockInitialValues({});await tester.pumpWidget(const CombineMonitorApp());await tester.pump();expect(find.text('DRONNINGBORG D7500'),findsOneWidget);expect(find.text('Tærskecylinder'),findsOneWidget);expect(find.text('Tømmesnegl'),findsOneWidget);expect(find.text('GPS'),findsNothing);});}
