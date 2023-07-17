import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets/button_field.dart';
import 'widgets/input_field.dart';

class ForgetPasswordReset extends StatefulWidget {
  const ForgetPasswordReset({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordReset> createState() => _ForgetPasswordResetState();
}

class _ForgetPasswordResetState extends State<ForgetPasswordReset> {
  final newPassController = new TextEditingController();
  final confirmPassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Image.asset(
            "assets/btn_back.png",
            width: 30,
            height: 30,
          ),
          // child: const Icon(Icons.navigate_before),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/message_success.png",
                      width: MediaQuery.of(context).size.width / 2.8,
                      height: MediaQuery.of(context).size.width / 2.8,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
                    Text(
                      "forget_password".tr(),
                      style: TextStyle(
                        fontSize:
                            2.7 * MediaQuery.of(context).size.height * 0.01,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 28),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 1.8 *
                                  MediaQuery.of(context).size.height *
                                  0.01,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          text: "enter_your_new_password_below".tr()),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 8),
                    InputField(
                        inputType: "new_password",
                        controller: newPassController),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    InputField(
                        inputType: "confirm_password",
                        controller: confirmPassController),
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
                    ButtonField(buttonType: "reset", onPressedCallback: () {}),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
