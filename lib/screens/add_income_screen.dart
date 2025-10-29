import 'package:flutter/material.dart';
import 'globals.dart';
import 'all_expense_screen.dart';

class AddIncomeScreen extends StatefulWidget {
  final String? source;
  final String? amount;
  final String? date;
  final int? index; // Optional index for editing

  const AddIncomeScreen({
    this.source,
    this.amount,
    this.date,
    this.index,
    super.key,
  });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  late TextEditingController _sourceController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController(text: widget.source ?? "");
    _amountController = TextEditingController(text: widget.amount ?? "");
    _dateController = TextEditingController(text: widget.date ?? "");
  }

  void _saveIncome() {
    int enteredAmount = int.tryParse(_amountController.text) ?? 0;

    final newIncome = {
      "source": _sourceController.text,
      "amount": enteredAmount,
      "date": _dateController.text,
    };

    if (widget.index != null) {
      // Update existing income
      incomesNotifier.value = [
        ...incomesNotifier.value..[widget.index!] = newIncome,
      ];
    } else {
      // Add new income
      incomesNotifier.value = [...incomesNotifier.value, newIncome];
    }

    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097A7),
        automaticallyImplyLeading: true,
        title: Text(
          widget.source == null ? "Add Income" : "Edit Income",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllExpenseScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            _buildTextField("Enter Source...", _sourceController),
            const SizedBox(height: 16),
            _buildTextField(
              "Enter Amount...",
              _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField("Enter Date...", _dateController),
            const SizedBox(height: 40),
            SizedBox(
              height: 82,
              width: 248,
              child: ElevatedButton(
                onPressed: _saveIncome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  "Save Income",
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
