import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'globals.dart'; // ✅ Make sure this file exists in lib/screens/

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

  File? _profileImage;

  // ✅ Pick image from gallery
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
      _saveProfile(); // update after selecting image
    }
  }

  // ✅ Save profile data globally
  void _saveProfile() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    int? budget = int.tryParse(_budgetLimitController.text.trim());
    int? goal = int.tryParse(_incomeGoalController.text.trim());

    final profile = {
      "name": name,
      "email": email,
      "budget": budget ?? 0,
      "goal": goal ?? 0,
      "image": _profileImage?.path,
    };

    updateProfile(profile); // ✅ save globally

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ✅ Clear all data
  void _clearData() {
    setState(() {
      _profileImage = null;
      _nameController.clear();
      _emailController.clear();
      _budgetLimitController.clear();
      _incomeGoalController.clear();
    });
    updateProfile({});
  }

  @override
  void initState() {
    super.initState();
    // Load existing profile if available
    if (profileDataNotifier.value.isNotEmpty) {
      final data = profileDataNotifier.value.first;
      _nameController.text = data["name"] ?? '';
      _emailController.text = data["email"] ?? '';
      _budgetLimitController.text = data["budget"]?.toString() ?? '';
      _incomeGoalController.text = data["goal"]?.toString() ?? '';
      if (data["image"] != null) {
        _profileImage = File(data["image"]);
      }
    }
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
      body: ValueListenableBuilder(
        valueListenable: profileDataNotifier,
        builder: (context, value, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.lightBlue[200],
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (value.isNotEmpty && value.first["image"] != null
                              ? FileImage(File(value.first["image"]))
                              : null),
                    child:
                        (_profileImage == null &&
                            (value.isEmpty || value.first["image"] == null))
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF004D60),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
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
                SizedBox(
                  height: 60,
                  width: 248,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
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
          );
        },
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
