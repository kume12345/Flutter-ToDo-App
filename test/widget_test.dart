// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/screens/todo_main.dart';

void main() {
  testWidgets('ToDoMain widget test', (WidgetTester tester) async {
    // Build the widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: ToDoMain(),
    ));

    // Verify the initial state of the widget
    expect(find.text('Lets DO It Time Tracker'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNothing); // No items initially

    // Tap the add button and wait for the dialog to appear
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Please enter your ToDO Item'), findsOneWidget);

    // Enter text and save
    await tester.enterText(find.byType(TextField), 'Test ToDo');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify item is added to the list
    expect(find.byType(CheckboxListTile), findsOneWidget);

    // Tap on an item's menu button (assuming one exists)
    await tester.tap(find.byType(PopupMenuButton));
    await tester.pumpAndSettle();

    // Verify menu options
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap edit and verify edit dialog
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // Verify edit dialog appears
    expect(find.text('Please update todo item details'), findsOneWidget);

    // Enter updated text and save
    await tester.enterText(find.byType(TextField), 'Updated ToDo');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify item is updated
    expect(find.text('Updated ToDo'), findsOneWidget);

    // Tap delete and verify item is deleted
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify item is deleted
    expect(find.byType(CheckboxListTile), findsNothing);
  });
}
