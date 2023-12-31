import 'package:cepapp/config/therme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDefault extends StatelessWidget {
  // label, obscureText = false, validator, controller, keyboardType, hint
  String label;
  bool obscureText = false;
  String? Function(String?) validator;
  TextInputType keyboardType;
  String hint;
  Icon icon;
  List<TextInputFormatter>? inputFormatters;
  TextEditingController controller;

  InputDefault(this.label, this.obscureText, this.keyboardType, this.icon,
      this.hint, this.inputFormatters,
      {super.key, required this.validator, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          validator: validator,
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusColor: AppColors.primaryColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
