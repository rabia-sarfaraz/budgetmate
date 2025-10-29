import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'globals.dart';
import 'profile_screen.dart'; // ✅ Added for navigation

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // ✅ Distinct Colors for Categories
  Color getColorForCategory(int index) {
    List<Color> colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.yellowAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.cyanAccent,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097A7),
        automaticallyImplyLeading: true,
        title: const Text(
          "Reports",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // ✅ Added settings icon for Profile navigation
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: expensesNotifier,
          builder: (context, expenses, _) {
            if (expenses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    "No expense data available yet!",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              );
            }

            // ✅ Category totals
            Map<String, double> categoryTotals = {};
            for (var expense in expenses) {
              String category = expense["category"] ?? "Other";
              double amount = (expense["amount"] is int)
                  ? expense["amount"].toDouble()
                  : expense["amount"] ?? 0.0;
              categoryTotals[category] =
                  (categoryTotals[category] ?? 0) + amount;
            }

            double totalAmount = categoryTotals.values.fold(0, (a, b) => a + b);

            // ✅ Prepare Pie Chart Sections
            List<PieChartSectionData> pieSections = [];
            int index = 0;
            categoryTotals.forEach((category, amount) {
              double percent = totalAmount == 0
                  ? 0
                  : (amount / totalAmount) * 100;
              pieSections.add(
                PieChartSectionData(
                  color: getColorForCategory(index),
                  value: percent,
                  title: category,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
              index++;
            });

            // ✅ Calculate Monthly Totals (Jan–Dec)
            Map<String, double> monthlyTotals = {
              'Jan': 0,
              'Feb': 0,
              'Mar': 0,
              'Apr': 0,
              'May': 0,
              'Jun': 0,
              'Jul': 0,
              'Aug': 0,
              'Sep': 0,
              'Oct': 0,
              'Nov': 0,
              'Dec': 0,
            };

            for (var expense in expenses) {
              String? dateStr = expense["date"];
              double amount = (expense["amount"] is int)
                  ? expense["amount"].toDouble()
                  : expense["amount"] ?? 0.0;

              if (dateStr != null && dateStr.isNotEmpty) {
                try {
                  int monthNum;

                  // ✅ Handle numeric month "1" or "2"
                  if (RegExp(r'^\d+$').hasMatch(dateStr)) {
                    monthNum = int.parse(dateStr);
                  }
                  // ✅ Handle DD-MM-YYYY (like "01-12-2025")
                  else if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(dateStr)) {
                    final parts = dateStr.split('-');
                    int month = int.parse(parts[1]);
                    monthNum = month;
                  }
                  // ✅ Handle standard YYYY-MM-DD (like "2025-12-01")
                  else {
                    DateTime date = DateTime.parse(dateStr);
                    monthNum = date.month;
                  }

                  String monthName = _getMonthAbbreviation(monthNum);
                  monthlyTotals[monthName] =
                      (monthlyTotals[monthName] ?? 0) + amount;
                } catch (_) {}
              }
            }

            List<String> months = monthlyTotals.keys.toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Expenses by Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF004D60),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        sections: pieSections,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Month-wise Comparison",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF004D60),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: months.length * 70,
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < months.length) {
                                      return Text(
                                        months[value.toInt()],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            barGroups: List.generate(months.length, (i) {
                              double y = monthlyTotals[months[i]] ?? 0;
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: y,
                                    color: getColorForCategory(i),
                                    width: 25,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ Convert month number → abbreviation
  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
