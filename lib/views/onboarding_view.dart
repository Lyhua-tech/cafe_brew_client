import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_view.dart';
import 'signup_view.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay for better text visibility if needed
          // Figma doesn't explicitly mention it but it's good for images
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Welcome Text
          Positioned(
            left: 20,
            right: 20,
            top: 511,
            child: Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: GoogleFonts.rougeScript(
                fontSize: 96,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Buttons Section
          Positioned(
            left: 20,
            right: 20,
            top: 602,
            child: Column(
              children: [
                const SizedBox(height: 5),
                // LOGIN Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFCB8944,
                      ), // Figma primary color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'LOGIN',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // SIGN UP Text
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(
                          0xFF70756B,
                        ), // Figma typography light-grey
                      ),
                      children: [
                        TextSpan(
                          text: "sign up",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFCB8944),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
