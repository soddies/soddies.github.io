import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firstproject/main.dart'; 


void main() {
  setUp(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(MoodEntryAdapter());
    await Hive.openBox<MoodEntry>('moodEntries');
  });

  tearDown(() async {
    // Clean up Hive after tests
    await Hive.deleteFromDisk();
  });

  testWidgets('MoodTrackerScreen displays a list of mood entries', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MoodProvider(),
        child: MaterialApp(home: MoodTrackerScreen()),
      ),
    );

    // Verify that the list is displayed.
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('AddMoodScreen allows selecting a mood and adding notes', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MoodProvider(),
        child: MaterialApp(home: AddMoodScreen()),
      ),
    );

    // Verify that the dropdown and text field are present.
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter some text into the notes field
    await tester.enterText(find.byType(TextField), 'Test Note');

    // Select a mood from the dropdown
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('sad').last);
    await tester.pumpAndSettle();

    // Tap the 'Save Mood' button and trigger a frame.
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    // Verify that the mood entry is added
    final moodProvider = Provider.of<MoodProvider>(tester.element(find.byType(MoodTrackerScreen)), listen: false);
    expect(moodProvider.moodEntries.length, 1);
  });
}
