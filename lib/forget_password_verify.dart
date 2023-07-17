import 'package:driver_app/widgets/otp_input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets/button_field.dart';

class ForgetPasswordVerify extends StatefulWidget {
  const ForgetPasswordVerify({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordVerify> createState() => _ForgetPasswordVerifyState();
}

class _ForgetPasswordVerifyState extends State<ForgetPasswordVerify> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  String? _otp;

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
                      "assets/message.png",
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
                              fontSize: 1.6 *
                                  MediaQuery.of(context).size.height *
                                  0.01,
                              fontFamily: 'Montserrat',
                              color: Colors.white),
                          children: [
                            TextSpan(
                                text: "an".tr(),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: "forget_password_otp_2".tr(),
                                style: TextStyle(
                                    fontSize: 1.8 *
                                        MediaQuery.of(context).size.height *
                                        0.01,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: "was_sent".tr(),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500))
                          ]),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 8),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 19,
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 25),
                              Expanded(child: OtpInput(_fieldOne, true)),
                              const SizedBox(width: 10),
                              Expanded(child: OtpInput(_fieldTwo, true)),
                              const SizedBox(width: 10),
                              Expanded(child: OtpInput(_fieldThree, true)),
                              const SizedBox(width: 10),
                              Expanded(child: OtpInput(_fieldFour, true)),
                              const SizedBox(width: 25),
                            ],
                          ),
                        )),
                    // Text(
                    //   _otp ?? 'please_enter_otp'.tr(),
                    //   style: TextStyle(
                    //       fontSize:
                    //           2 * MediaQuery.of(context).size.height * 0.01,
                    //       fontFamily: 'Montserrat',
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.white),
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    ButtonField(
                        buttonType: "verify",
                        onPressedCallback: () {
                          String str = _fieldOne.text +
                              _fieldTwo.text +
                              _fieldThree.text +
                              _fieldFour.text;
                          if (str == "1234") {
                            Navigator.pushNamed(context, "/verify_password");
                            return;
                          }
                          setState(() {
                            _otp = _fieldOne.text +
                                _fieldTwo.text +
                                _fieldThree.text +
                                _fieldFour.text;
                          });

                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                        "Please input \"1234\" to verify"),
                                    actions: [
                                      TextButton(
                                          onPressed: () => {
                                                _fieldOne.text = "",
                                                _fieldTwo.text = "",
                                                _fieldThree.text = "",
                                                _fieldFour.text = "",
                                                Navigator.pop(context)
                                              },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        }),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 1.3 *
                                  MediaQuery.of(context).size.height *
                                  0.01,
                              color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Did not receive the verification OTP?\n",
                              style: TextStyle(
                                  fontSize: 1.4 *
                                      MediaQuery.of(context).size.height *
                                      0.01,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            TextSpan(
                                text: "Resend OTP in ",
                                style: TextStyle(
                                    fontSize: 1.4 *
                                        MediaQuery.of(context).size.height *
                                        0.01,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            TextSpan(
                                text: "00:59",
                                style: TextStyle(
                                    fontSize: 1.5 *
                                        MediaQuery.of(context).size.height *
                                        0.01,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.yellow))
                          ]),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
