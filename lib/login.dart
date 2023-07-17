import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:driver_app/commons.dart';
import 'package:driver_app/sub_main.dart';
import 'package:driver_app/widgets/button_field.dart';
import 'package:driver_app/widgets/input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_indicator/loading_indicator.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class MyLogin extends StatelessWidget {
  MyLogin({super.key});

  final nameController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;
  static setToken() async {
    developer.log("init");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/alnabali/public/android/driver/token'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    String token = responseJson["token"];
    Commons.token = token;
  }

  login(BuildContext context, TextEditingController nameCon,
      TextEditingController passCon) async {
    if (nameCon.text == "" && passCon.text == "") {
      Commons.showErrorMessage("Input Name and Password!");
      return;
    }
    showLoadingIndicator(context, true);

    Map data = {
      'email': nameCon.text,
      'password': passCon.text,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN': Commons.token
    };

    requestHeaders['cookie'] = Commons.cookie;

    String url = "${Commons.baseUrl}supervisor/login";
    var response =
        await http.post(Uri.parse(url), body: data, headers: requestHeaders);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('login_id', 'null');
    preferences.setString('name', 'null');
    preferences.setString('dateType', 'null');
    preferences.setBool('isLogin', false);
    if (response.statusCode == 200) {
      developer.log("msg7" + "success http request");
      if (responseJson['result'] == "Invalid SuperVisor") {
        showLoadingIndicator(context, false);

        Commons.showErrorMessage('Invalid User');
      } else if (responseJson['result'] == "Invalid Password") {
        showLoadingIndicator(context, false);

        Commons.showErrorMessage('Invalid Password');
      } else {
        Commons.login_id = responseJson['id'].toString();
        Commons.name = responseJson['name'].toString();
        Commons.dateType = responseJson['date'].toString();

        Commons.isLogin = true;

        preferences.setString('login_id', responseJson['id'].toString());
        preferences.setString('name', responseJson['name'].toString());
        preferences.setString("dateType", responseJson['date'].toString());

        preferences.setBool('isLogin', true);

        Navigator.pushNamed(context, "/main");
        // setState( () {
        sharedPreferences.setString("token", Commons.token);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => SubMain()),
            (route) => false);
        // })
      }
    } else {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0);
    }
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ));
  }

  void showLoadingIndicator(BuildContext context, bool type) {
    print(type);
    if (type == true) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // Show loading indicator
          return const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: _kDefaultRainbowColors,
                strokeWidth: 4.0,
              ),
            ),
          );
        },
      );
    } else if (type == false) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Close the dialog
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setToken();
    String labelText = "username".tr();
    String passText = "password".tr();
    return Stack(children: [
      SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/login.png"),
                        fit: BoxFit.cover)),
                height: MediaQuery.of(context).size.height,
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 14),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/empty.png",
                        width: MediaQuery.of(context).size.width / 2.1,
                        height: MediaQuery.of(context).size.width / 2.1,
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Text(
                        "login".tr(),
                        style: TextStyle(
                          fontSize:
                              3.5 * MediaQuery.of(context).size.height * 0.01,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      // InputField(
                      //     inputType: "username", controller: nameController),
                      SizedBox(height: MediaQuery.of(context).size.height / 20),
                      // InputField(
                      //     inputType: "password",
                      //     controller: passController,
                      //     editComplete: () =>
                      //         login(context, nameController, passController)),
                      SizedBox(height: MediaQuery.of(context).size.height / 13),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            label: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(labelText),
                            ),
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 24,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5)),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextField(
                          onSubmitted: (value) {
                            login(context, nameController, passController);
                          },
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            label: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(passText),
                            ),
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 24,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5)),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textInputAction:
                              TextInputAction.done, // Moves focus to next.
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ButtonField(
                            buttonType: "login",
                            onPressedCallback: () {
                              login(context, nameController, passController);
                            }),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height / 9),

                      // GestureDetector(
                      //     onTap: () {
                      //       // setToken();
                      //       Navigator.pushNamed(context, "/forget_password");
                      //     },
                      //     child: Text(
                      //       "forget_password".tr(),
                      //       style: TextStyle(
                      //           shadows: const [
                      //             Shadow(
                      //                 color: Colors.white, offset: Offset(0, -5))
                      //           ],
                      //           decoration: TextDecoration.underline,
                      //           color: Colors.transparent,
                      //           fontSize: 2.4 *
                      //               MediaQuery.of(context).size.height *
                      //               0.008,
                      //           letterSpacing: 1.2,
                      //           decorationThickness: 2,
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.w500,
                      //           decorationColor: Colors.white),
                      //     )),
                    ],
                  ),
                )),
          ),
        ),
      ),
    ]);
  }
}
