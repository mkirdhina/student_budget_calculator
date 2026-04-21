import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Budget Calculator',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 223, 113, 194),
        ),
        useMaterial3: true,
      ),
      home: const MyCalculator(),
    );
  }
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final audio = AudioPlayer();

  double total = 0;
  double dailyBudget = 0;
  double remaining = 0;
  String message = "";
  String currentImage = "assets/images/coverMoney.jpg";

  void calculateBudget() {
    double expense = double.tryParse(expenseController.text) ?? 0;
    double budget = double.tryParse(budgetController.text) ?? 0;
    double days = double.tryParse(daysController.text) ?? 0;
    setState(() {
      total = expense * days;
      remaining = budget - total;

      if (days > 0) {
        dailyBudget = budget / days;
      }
      if (days <= 0) {
        message = "Days must be greater than 0";
        currentImage = "assets/images/coverMoney.jpg";
        return;
      }

      if (remaining < 0) {
        message = "You are over budget!";
        audio.play(AssetSource('audio/sadNoMoney.mp3'));
        currentImage = "assets/images/catNoMoney.jpg";
      } else {
        message = "WOW! You are within budget";
        audio.play(AssetSource('audio/alertWithinBudget.mp3'));
        currentImage = "assets/images/manyMoney.jpg";
      }
    });
  }

  void reset() {
    setState(() {
      expenseController.text = "";
      daysController.text = "";
      budgetController.text = "";
      total = 0;
      dailyBudget = 0;
      remaining = 0;
      message = "";
      currentImage = "assets/images/coverMoney.jpg";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Student Budget Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Total Budget (RM)",
              ), // berapa kita guna harini
            ),
            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Daily Expense"),
            ),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of Days",
              ), // budget untuk
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: calculateBudget,
                    child: const Text("Calculate"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "Total Spent: RM $total",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Remaining Budget: RM ${remaining.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Daily Budget: RM ${dailyBudget.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 211, 12, 22),
              ),
            ),
            Image.asset(currentImage, width: 450, height: 300),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: reset, child: const Text("Reset")),
          ],
        ),
      ),
    );
  }
}
