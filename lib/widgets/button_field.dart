import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ButtonField extends StatefulWidget {
  const ButtonField(
      {Key? key, required this.buttonType, required this.onPressedCallback})
      : super(key: key);

  final String buttonType;
  final VoidCallback onPressedCallback;

  @override
  State<ButtonField> createState() => _ButtonFieldState();
}

class _ButtonFieldState extends State<ButtonField> {
  @override
  Widget build(BuildContext context) {
    String displayName = "";

    switch (widget.buttonType) {
      case "login":
        displayName = "login".tr();
        break;
      case "send":
        displayName = "send".tr();
        break;
      case "verify":
        displayName = "verify".tr();
        break;
      case "reset":
        displayName = "reset".tr();
        break;
      default:
        break;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 19,
      width: MediaQuery.of(context).size.width / 1.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 19,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Image.asset('assets/btn_bg.png'),
          ),
          Positioned.fill(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const StadiumBorder(),
                foregroundColor: Colors.orange,
                textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 2 * MediaQuery.of(context).size.height * 0.01,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: widget.onPressedCallback,
              child: Text(displayName),
            ),
          ),
        ],
      ),
    );
  }
}
