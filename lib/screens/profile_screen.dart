import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _budgetLimitController = TextEditingController();
  final TextEditingController _incomeGoalController = TextEditingController();

  File? _profileImage; // ✅ For storing selected image

  // ✅ Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  // ✅ Function to clear all fields
  void _clearData() {
    setState(() {
      _profileImage = null;
      _nameController.clear();
      _emailController.clear();
      _budgetLimitController.clear();
      _incomeGoalController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0097A7),
        automaticallyImplyLeading: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // ✅ Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.lightBlue[200],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF004D60),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Upload Photo Button
            SizedBox(
              height: 60,
              width: 200,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  "Upload Photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Text Fields (4)
            _buildTextField("Enter your name", _nameController),
            const SizedBox(height: 10),
            _buildTextField("Enter your email", _emailController),
            const SizedBox(height: 10),
            _buildTextField(
              "Enter budget limit",
              _budgetLimitController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Enter income goal",
              _incomeGoalController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 40),

            // ✅ Update Budget Button
            SizedBox(
              height: 60,
              width: 248,
              child: ElevatedButton(
                onPressed: () {
                  String name = _nameController.text;
                  String email = _emailController.text;
                  int? budgetLimit = int.tryParse(
                    _budgetLimitController.text.trim(),
                  );
                  int? incomeGoal = int.tryParse(
                    _incomeGoalController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "✅ Budget updated!\nName: $name\nEmail: $email\nBudget: ${budgetLimit ?? 0}\nIncome Goal: ${incomeGoal ?? 0}",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  "Update Budget",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Clear Data Button
            SizedBox(
              height: 60,
              width: 248,
              child: ElevatedButton(
                onPressed: _clearData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
                  "Clear Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
