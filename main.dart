import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Study Planner",
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        fontFamily: "Roboto",
      ),
      home: const PlannerPage(),
    );
  }
}

class Subject {
  String name;
  String difficulty;

  Subject(this.name, this.difficulty);
}

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {

  final subjectController = TextEditingController();
  final daysController = TextEditingController();

  String difficulty = "Medium";

  List<Subject> subjects = [];
  List<String> schedule = [];

  void addSubject() {
    if (subjectController.text.isEmpty) return;

    setState(() {
      subjects.add(Subject(subjectController.text, difficulty));
      subjectController.clear();
    });
  }

  void generatePlan() {

    int days = int.tryParse(daysController.text) ?? 0;

    schedule.clear();

    if (subjects.isEmpty || days == 0) return;

    int index = 0;

    for (int day = 1; day <= days; day++) {

      String plan = "Day $day: ";

      if (index < subjects.length) {
        plan += subjects[index].name;
        index++;
      }

      schedule.add(plan);
    }

    setState(() {});
  }

  Color difficultyColor(String diff) {
    if (diff == "Hard") return Colors.red;
    if (diff == "Medium") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("🤖 AI Study Planner"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject Name",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButton<String>(
                value: difficulty,
                items: const [
                  DropdownMenuItem(value: "Easy", child: Text("Easy")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Hard", child: Text("Hard")),
                ],
                onChanged: (value) {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: addSubject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text("Add Subject"),
              ),

              const SizedBox(height: 20),

              const Text(
                "Subjects",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (_, i) {

                    final sub = subjects[i];

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(sub.name),
                        subtitle: Text(
                          sub.difficulty,
                          style: TextStyle(
                            color: difficultyColor(sub.difficulty),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              subjects.removeAt(i);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Days Until Exam",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: generatePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Generate Study Plan"),
              ),

              const SizedBox(height: 20),

              const Text(
                "Study Schedule",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (_, i) {
                    return Card(
                      color: Colors.green[100],
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(schedule[i]),
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}