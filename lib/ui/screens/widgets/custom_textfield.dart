
import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';

class CustomTextfield extends StatelessWidget {
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final TextEditingController controller; 

  const CustomTextfield({
    super.key,
    required this.icon,
    required this.obscureText,
    required this.hintText,
    required this.controller, // Menambahkan parameter controller
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, 
      obscureText: obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(icon, color: Constants.blackColor.withOpacity(.3)),
        hintText: hintText,
      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
    );
  }
}