import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'report_screen.dart'; // ✅ Added this import
import 'globals.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ✅ Color function based on percentage
  Color getColorForPercentage(double percent) {
    if (percent <= 25) {
      return Colors.redAccent;
    } else if (percent <= 50) {
      return Colors.yellowAccent;
    } else if (percent <= 75) {
      return Colors.blueAccent;
    } else {
      return Colors.green;
    }
  }

  // ✅ Generate distinct colors for categories
  Color getColorForCategory(int index) {
    List<Color> colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.yellowAccent,
      Colors.tealAccent,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF0097A7),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Listen to incomesNotifier
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: incomesNotifier,
                builder: (context, incomes, _) {
                  int totalIncome = incomes.fold<int>(
                    0,
                    (sum, item) => sum + ((item["amount"] ?? 0) as int),
                  );

                  // ✅ Listen to expensesNotifier inside
                  return ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: expensesNotifier,
                    builder: (context, expenses, _) {
                      int totalExpenses = expenses.fold<int>(
                        0,
                        (sum, item) => sum + ((item["amount"] ?? 0) as int),
                      );
                      int remainingBudget = totalIncome - totalExpenses;

                      double remainingPercent = totalIncome == 0
                          ? 0
                          : (remainingBudget / totalIncome) * 100;

                      // Prepare PieChart sections for expenses by category
                      Map<String, int> categoryTotals = {};
                      for (var expense in expenses) {
                        String category = expense["category"] ?? "Other";
                        int amount = expense["amount"] ?? 0;
                        if (categoryTotals.containsKey(category)) {
                          categoryTotals[category] =
                              categoryTotals[category]! + amount;
                        } else {
                          categoryTotals[category] = amount;
                        }
                      }

                      List<PieChartSectionData> sections = [];
                      int index = 0;
                      categoryTotals.forEach((category, amount) {
                        double percent = totalIncome == 0
                            ? 0
                            : (amount / totalIncome) * 100;
                        sections.add(
                          PieChartSectionData(
                            value: percent,
                            color: getColorForCategory(index),
                            title: "${percent.toStringAsFixed(0)}%",
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                        index++;
                      });

                      // Add remaining budget as a section
                      sections.add(
                        PieChartSectionData(
                          value: remainingPercent,
                          color: getColorForPercentage(remainingPercent),
                          title: "${remainingPercent.toStringAsFixed(0)}%",
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      return Column(
                        children: [
                          _buildInfoCard("Total income", "Rs $totalIncome"),
                          const SizedBox(height: 16),
                          _buildInfoCard("Total expenses", "Rs $totalExpenses"),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            "Remaining budget",
                            "Rs $remainingBudget",
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Spending Breakdown",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF004D60),
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 40,
                                sections: sections,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomButton(
                    context,
                    "Add Expense",
                    Colors.redAccent,
                    const AddExpenseScreen(),
                  ),
                  _buildBottomButton(
                    context,
                    "Add Income",
                    Colors.green,
                    const AddIncomeScreen(),
                  ),
                  // ✅ Updated this button to navigate to ReportScreen
                  _buildBottomButton(
                    context,
                    "View Report",
                    Colors.blue,
                    const ReportScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF004D60),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF004D60),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    String label,
    Color color,
    Widget? screen,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
