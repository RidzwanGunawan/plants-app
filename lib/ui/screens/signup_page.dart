import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/ui/screens/signin_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty) {
      _showErrorSnackbar("Semua field harus diisi");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackbar("Password minimal 6 karakter");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      await Flushbar(
        message: "Akun berhasil dibuat! Silakan login.",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        messageColor: Colors.white,
      ).show(context);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const SignIn(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackbar("Error: ${e.toString()}");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/signup.png'),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 15),

                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    decoration: _inputDecoration("Full Name", Icons.person),
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Password", Icons.lock),
                  ),
                  const SizedBox(height: 25),

                  // Sign Up Button or Loader
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Constants.primaryColor,
                          ),
                        )
                      : GestureDetector(
                          onTap: _signUp,
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: const Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),

                  // Go to Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: const SignIn(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Have an Account? ',
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: Constants.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
