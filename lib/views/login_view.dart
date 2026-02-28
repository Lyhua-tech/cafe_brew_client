import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_view.dart';
import 'forgot_password_view.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'main_layout_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Unique Brew",
          style: GoogleFonts.pottaOne(
            color: const Color(0xFFB0652F),
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo placeholder or image
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E9D2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_cafe,
                    size: 60,
                    color: Color(0xFFCB8944),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                "Log In",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF363A33),
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField(
                controller: _emailController,
                hintText: "email address",
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _passController,
                hintText: "password",
                isPassword: true,
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot password",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFCB8944),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Consumer<AuthViewModel>(
                builder: (context, authVm, child) {
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authVm.isLoading
                          ? null
                          : () async {
                              bool success = await authVm.login(
                                _emailController.text,
                                _passController.text,
                              );
                              if (success && context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainLayoutView(),
                                  ),
                                  (route) => false,
                                );
                              } else if (authVm.errorMessage != null &&
                                  context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authVm.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCB8944),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: authVm.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF70756B),
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpView()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF363A33),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBE6), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscureText,
        style: GoogleFonts.poppins(color: const Color(0xFF363A33)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF91958E),
            fontSize: 15,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF60635E),
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
