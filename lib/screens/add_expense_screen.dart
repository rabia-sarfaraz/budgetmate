import 'package:flutter/material.dart';
import 'globals.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097A7),
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Expense",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            _buildTextField("Enter Title...", _titleController),
            const SizedBox(height: 16),
            _buildTextField("Enter Category...", _categoryController),
            const SizedBox(height: 16),
            _buildTextField(
              "Enter Amount...",
              _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField("Enter Date...", _dateController),
            const SizedBox(height: 16),
            _buildTextField("Enter Note...", _noteController),
            const SizedBox(height: 40),
            SizedBox(
              height: 82,
              width: 248,
              child: ElevatedButton(
                onPressed: () {
                  int enteredAmount = int.tryParse(_amountController.text) ?? 0;

                  // ✅ Add to notifier
                  expensesNotifier.value = [
                    ...expensesNotifier.value,
                    {
                      "title": _titleController.text,
                      "category": _categoryController.text,
                      "amount": enteredAmount,
                      "date": _dateController.text,
                      "note": _noteController.text,
                    },
                  ];

                  Navigator.pop(context); // Return to WelcomeScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  "Save Expense",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 59,
      width: 327,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 17,
            color: Color(0xFF004D60),
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 17,
          color: Color(0xFF004D60),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
