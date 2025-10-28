import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF112552), Color(0xFF2ED3D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // --- Main Content (logo + texts) ---
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // moves content slightly below top
                // --- Logo ---
                Image.asset(
                  'assets/images/app_logo1.png', // 🔹 your logo path
                  width: 120,
                  height: 120,
                ),

                const SizedBox(height: 30),

                // --- Welcome Text ---
                const Text(
                  "     Welcome to BudgetMate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w900, // Black weight
                  ),
                ),

                const SizedBox(height: 15),

                // --- Tagline ---
                const Text(
                  "Your budget, your control",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w200, // Extra light
                  ),
                ),
              ],
            ),

            // --- Bottom Rectangle with Button ---
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 219,
                decoration: const BoxDecoration(
                  color: Color(0xFF76B7F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Later navigate to next screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A73DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Begin Now",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w800, // extra bold
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios, // ➤ thin right arrow style
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
