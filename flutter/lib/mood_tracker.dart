import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MoodEntryAdapter());
  await Hive.openBox<MoodEntry>('moodEntries');
  runApp(MyApp());
}

class MoodEntry {
  final DateTime date;
  final String mood;
  final String? notes;

  MoodEntry({required this.date, required this.mood, this.notes});
}

class MoodEntryAdapter extends TypeAdapter<MoodEntry> {
  @override
  final int typeId = 0;

  @override
  MoodEntry read(BinaryReader reader) {
    final date = DateTime.parse(reader.readString());
    final mood = reader.readString();
    final notes = reader.readString();
    return MoodEntry(date: date, mood: mood, notes: notes);
  }

  @override
  void write(BinaryWriter writer, MoodEntry obj) {
    writer.writeString(obj.date.toIso8601String());
    writer.writeString(obj.mood);
    writer.writeString(obj.notes ?? '');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoodProvider(),
      child: MaterialApp(
        title: 'Трекер настроения',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MoodTrackerScreen(),
      ),
    );
  }
}

class MoodProvider with ChangeNotifier {
  final Box<MoodEntry> _moodBox = Hive.box<MoodEntry>('moodEntries');

  List<MoodEntry> get moodEntries => _moodBox.values.toList();

  void addMoodEntry(MoodEntry entry) {
    _moodBox.add(entry);
    notifyListeners();
  }
}

class MoodTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Трекер настроения'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MoodChart(moodEntries: moodProvider.moodEntries),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: moodProvider.moodEntries.length,
              itemBuilder: (context, index) {
                final entry = moodProvider.moodEntries[index];
                return ListTile(
                  title: Text('${entry.date}'),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Настроение: ${entry.mood}'),
                        if (entry.notes != null && entry.notes!.isNotEmpty)
                          Text('Заметки: ${entry.notes}'),
                    ],
                  )
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMoodScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddMoodScreen extends StatefulWidget {
  @override
  _AddMoodScreenState createState() => _AddMoodScreenState();
}

class _AddMoodScreenState extends State<AddMoodScreen> {
  final TextEditingController notesController = TextEditingController();
  String selectedMood = 'happy';

  final List<String> moods = ['happy', 'sad', 'neutral', 'angry', 'excited'];

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить настроение'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedMood,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMood = newValue!;
                });
              },
              items: moods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Заметки'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newMoodEntry = MoodEntry(
                  date: DateTime.now(),
                  mood: selectedMood,
                  notes: notesController.text,
                );
                moodProvider.addMoodEntry(newMoodEntry);
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  MoodChart({required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: moodEntries.asMap().entries.map((entry) {
              int index = entry.key;
              MoodEntry moodEntry = entry.value;
              double yValue;

              switch (moodEntry.mood) {
                case 'happy':
                  yValue = 5;
                  break;
                case 'excited':
                  yValue = 4;
                  break;
                case 'neutral':
                  yValue = 3;
                  break;
                case 'sad':
                  yValue = 2;
                  break;
                case 'angry':
                  yValue = 1;
                  break;
                default:
                  yValue = 0;
              }

              return FlSpot(index.toDouble(), yValue);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
