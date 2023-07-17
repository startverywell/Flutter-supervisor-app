import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String inputType;
  final TextEditingController controller;
  VoidCallback? editComplete;

  InputField(
      {Key? key,
      required this.inputType,
      required this.controller,
      this.editComplete})
      : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    TextInputType textInputType = TextInputType.text;
    bool isObscure = false;
    String displayName = "";

    switch (widget.inputType) {
      case "username":
        textInputType = TextInputType.text;
        displayName = "username".tr();
        break;
      case "password":
        textInputType = TextInputType.text;
        displayName = "password".tr();
        isObscure = true;
        break;
      case "new_password":
        textInputType = TextInputType.text;
        displayName = "new_password".tr();
        isObscure = true;
        break;
      case "confirm_password":
        textInputType = TextInputType.text;
        displayName = "confirm_password".tr();
        isObscure = true;
        break;
      case "mobile":
        textInputType = TextInputType.number;
        displayName = "mobile_number".tr();
        break;
      default:
        break;
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height / 19,
      width: MediaQuery.of(context).size.width / 1.4,
      child: TextField(
        keyboardType: textInputType,
        obscureText: isObscure,
        cursorColor: Colors.white,
        cursorHeight: 25,
        controller: widget.controller,
        onEditingComplete: widget.editComplete,
        decoration: InputDecoration(
          label: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(displayName),
          ),
          labelStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              letterSpacing: 1.5),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 24,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.white, width: 1.5)),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
