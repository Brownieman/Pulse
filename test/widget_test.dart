// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:new_task_manage/main.dart';

void main() {
  testWidgets('App renders auth screen by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NewTaskManageApp());
    // Expect auth screen title
    expect(find.text('Welcome to Pulse'), findsOneWidget);
    // And email field exists
    expect(find.text('Email'), findsOneWidget);
  });
}
