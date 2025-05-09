import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/ui/root_page.dart';
import 'package:plants_app/ui/screens/forgot_password.dart';
import 'package:plants_app/ui/screens/signup_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _signInWithEmailPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackbar("Email dan password wajib diisi.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const RootPage(),
          type: PageTransitionType.bottomToTop,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "Email atau password salah.";
          break;
        case 'invalid-email':
          errorMessage = "Format email tidak valid.";
          break;
        case 'user-disabled':
          errorMessage = "Akun ini telah dinonaktifkan.";
          break;
        case 'user-not-found':
          errorMessage = "Email tidak ditemukan.";
          break;
        case 'wrong-password':
          errorMessage = "Password salah.";
          break;
        default:
          errorMessage = "Login gagal. (${e.code})";
      }
      _showErrorSnackbar(errorMessage);
    } finally {
      setState(() => isLoading = false);
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
                  Image.asset('assets/images/signin.png'),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 15),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Password", Icons.lock),
                  ),
                  const SizedBox(height: 20),

                  // Sign In Button
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Constants.primaryColor,
                          ),
                        )
                      : GestureDetector(
                          onTap: _signInWithEmailPassword,
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: const Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: const ForgotPassword(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot Password? ',
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            TextSpan(
                              text: 'Reset Here',
                              style: TextStyle(color: Constants.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Go to Sign Up
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: const SignUp(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'New to Planty? ',
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            TextSpan(
                              text: 'Register',
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
