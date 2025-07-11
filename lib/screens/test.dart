import 'package:flutter/material.dart';
import 'package:grostore/helpers/common_functions.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // خلفية عصرية وناعمة
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  getAssetLogo('logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              strokeWidth: 4,

              valueColor: AlwaysStoppedAnimation(Color(0xFF00CFC1)), // لون حديث
            ),
            const SizedBox(height: 20),
            const Text(
              'جاري تحميل التطبيق...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
