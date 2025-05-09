import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/ui/screens/signin_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Fungsi untuk reset password
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackbar("Email wajib diisi.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      // Hentikan loader terlebih dahulu
      setState(() {
        isLoading = false;
      });

      // Tampilkan notifikasi berhasil
      await Flushbar(
        message: "Link reset password telah dikirim! Periksa email Anda.",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 28,
        ),
        messageColor: Colors.white,
      ).show(context);

      // Navigasi ke halaman login setelah notifikasi muncul
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
      _showErrorSnackbar("Terjadi kesalahan: ${e.toString()}");
    }
  }

  // Fungsi untuk menampilkan Snackbar error
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar tetap responsif dengan menyesuaikan lebar layar
                  Image.asset(
                    'assets/images/forgot-password.png',
                    width: size.width, // Memastikan gambar mengisi lebar layar
                    fit: BoxFit.cover, // Menjaga gambar tetap proporsional
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Forgot\nPassword',
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 15),

                  // Tombol Reset Password atau Loader
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Constants.primaryColor,
                          ),
                        )
                      : GestureDetector(
                          onTap: _resetPassword,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: const Center(
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),

                  // Link untuk kembali ke halaman login
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
