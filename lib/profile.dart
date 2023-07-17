import 'dart:convert';
import 'dart:ui';

import 'package:driver_app/commons.dart';
import 'package:driver_app/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/constants.dart';
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  bool isLoading = true;

  @override
  void initState() {
    Commons.isTrip = false;
    super.initState();
    _initPackageInfo();
    getUserData();
    setLanguage();
  }

  Future<void> setLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? lang = sharedPreferences.getBool('lang');
    if (lang != null) {
      _tabController.index = lang ? 0 : 1;
    }
  }

  String userProfileImage = "";
  String? username;
  String? workingHours;
  String? totalTrips;
  String version = "--";
  String buildNumber = "--";
  String? totalDistance;
  bool? language = false;

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    developer.log('PackageInfo: ${info.version} ${info.buildNumber}');
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  getUserData() async {
    String url = "${Commons.baseUrl}supervisor/profile/${Commons.login_id}";

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      'X-CSRF-TOKEN': Commons.token
    };
    var response = await http.get(Uri.parse(url), headers: requestHeaders);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var user = responseJson['driver'];
      setState(() {
        username = user['name'];
      });
      if (user['profile_image'] != null) {
        setState(() {
          userProfileImage = user['profile_image'];
        });
      }
      if (user['workingHours'] != null) {
        setState(() {
          workingHours = user['workingHours'].toString();
          var myDouble = double.parse(user['workingHours'].toString());
          assert(myDouble is double);
        });
      }
      if (user['totalTrips'] != null) {
        setState(() {
          totalTrips = user['totalTrips'].toString();
        });
      }
      if (user['totalDistance'] != null) {
        setState(() {
          totalDistance = user['totalDistance'].toString();
        });
      }
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  Future<bool?> arabicMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isArabic");
  }

  void save(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isArabic", value);
    language = value;
  }

  List<Widget> langList() {
    List<Widget> languageList = [];

    if (language == false) {
      languageList.add(Tab(
        child: Center(
          child: Text("English"),
        ),
      ));
      languageList.add(Tab(
        child: Center(
          child: Text("عربي"),
        ),
      ));
    } else {
      languageList.add(Tab(
        child: Center(
          child: Text("English"),
        ),
      ));
      languageList.add(Tab(
        child: Center(
          child: Text("عربي"),
        ),
      ));
    }
    return languageList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_notification.png"),
                        fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height / 6,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 200),
                        child: _buildList(),
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height / 100),
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height / 13.5,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color.fromRGBO(244, 130, 34, 1),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/main');
                                },
                                child: Container(
                                    child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: MediaQuery.of(context).size.width *
                                          0.1,
                                      top: 20,
                                      bottom: 15),
                                  child:
                                      Image.asset("assets/navbar_track2.png"),
                                )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/trip');
                                },
                                child: Container(
                                    child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: MediaQuery.of(context).size.width *
                                          0.11,
                                      top: 20,
                                      bottom: 15),
                                  child: Image.asset("assets/navbar_trip.png"),
                                )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/notification');
                                },
                                child: Container(
                                    child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: MediaQuery.of(context).size.width *
                                          0.11,
                                      top: 20,
                                      bottom: 15),
                                  child: Image.asset(
                                      "assets/navbar_notification.png"),
                                )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 7),
                                child: TextField(
                                  style: const TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                      enabled: false,
                                      prefixIcon: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 5, top: 10, bottom: 10),
                                        child: Image.asset(
                                          "assets/navbar_account.png",
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(1),
                                      hintText: "account".tr(),
                                      hintStyle: const TextStyle(
                                          color:
                                              Color.fromRGBO(244, 130, 34, 1),
                                          fontSize: 12,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)))),
                                ),
                              ),
                            ],
                          )),
                    ]))));
  }

  Widget _buildList() {
    // create map to group notifications by date
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await getUserData();
            return;
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/bg_profile.png"),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter)),
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsetsDirectional.only(
                            top: MediaQuery.of(context).size.height / 5.4),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userProfileImage),
                          radius: 53,
                          backgroundColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(244, 130, 34, 1)),
                                borderRadius: BorderRadius.circular(55)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsetsDirectional.only(top: 8),
                        child: Text(
                          username ?? 'unknown',
                          style: TextStyle(
                              color: Color.fromRGBO(244, 130, 34, 1),
                              fontFamily: 'Montserrat',
                              fontSize: MediaQuery.of(context).size.height / 50,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                          margin: EdgeInsetsDirectional.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                      child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        top: MediaQuery.of(context).size.width /
                                            100,
                                        bottom:
                                            MediaQuery.of(context).size.width /
                                                100),
                                    child: Image.asset(
                                      "assets/time.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                    ),
                                  )),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        top: MediaQuery.of(context).size.width *
                                            0.005,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.005),
                                    child: Text(
                                      workingHours ?? '0.0',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(244, 130, 34, 1),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              60,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "working_hours".tr(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.01,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: Image.asset(
                                      "assets/meter.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                    ),
                                  )),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.005,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.005),
                                    child: Text(
                                      totalDistance ?? 'unknown',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(244, 130, 34, 1),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              60,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Text(
                                      "total_distance".tr(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.01,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: Image.asset(
                                      "assets/route.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                    ),
                                  )),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        top: MediaQuery.of(context).size.width *
                                            0.005,
                                        bottom:
                                            MediaQuery.of(context).size.width *
                                                0.005),
                                    child: Text(
                                      totalTrips ?? '0',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(244, 130, 34, 1),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              60,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsDirectional.only(
                                        start:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    child: Text(
                                      "total_trips".tr(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      FutureBuilder<bool?>(
                        future: arabicMode(),
                        builder: (context, _snapshot) {
                          // return Switch(
                          //   value: _snapshot.data ?? false,
                          //   onChanged: (value) {
                          //     save(value);
                          //     setState(() {
                          //       if (value) {
                          //         context.setLocale(Locale('ar', 'JO'));
                          //       } else {
                          //         context.setLocale(Locale('en', 'UK'));
                          //       }
                          //     });
                          //   },
                          // );
                          return Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              color: kColorPrimaryBlue,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicator: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color.fromRGBO(244, 130, 34, 1)),
                              labelColor: Colors.white,
                              labelPadding: const EdgeInsets.only(top: 5),
                              unselectedLabelColor: Colors.white,
                              labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              tabs: langList(),
                              onTap: (value) async {
                                if (value == 0) {
                                  save(false);
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setBool('lang', true);
                                  setState(() {
                                    context.setLocale(Locale('en', 'UK'));
                                  });
                                } else {
                                  save(true);
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setBool('lang', false);
                                  setState(() {
                                    context.setLocale(Locale('ar', 'JO'));
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      Container(
                        child: SizedBox(
                            child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile_edit');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color.fromRGBO(244, 130, 34, 1),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width / 1.7, 30),
                            alignment: Alignment.center,
                          ),
                          child: Text(
                            // "Edit Profile",
                            'edit_profile'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(244, 130, 34, 1),
                            ),
                          ),
                        )),
                      ),
                      Container(
                        child: SizedBox(
                            child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/password_change');
                          },
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Color.fromRGBO(244, 130, 34, 1),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width / 1.7, 30),
                              alignment: Alignment.center),
                          child: Text(
                            "change_password".tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(244, 130, 34, 1),
                            ),
                          ),
                        )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                      ),
                      Container(
                          child: ElevatedButton(
                        onPressed: () {
                          showAlertDialog(BuildContext context) {
                            // set up the buttons
                            Widget cancelButton = TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(244, 130, 34, 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                padding: const EdgeInsets.all(0.0),
                              ),
                              onPressed: () async {
                                Commons.token = "";
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setString('login_id', 'not');
                                preferences.setBool('isLogin', true);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyLogin(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 25,
                                alignment: Alignment.center,
                                child: Text(
                                  "yes".tr(),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            Widget continueButton = TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                padding: const EdgeInsets.all(0.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.grey, Colors.white]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'no'.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(244, 130, 34, 1),
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );

                            // set up the AlertDialog

                            AlertDialog alert = AlertDialog(
                              title: Center(
                                child: Text(
                                  "log_out1".tr(),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        "assets/log_out.png",
                                        width: 130,
                                        height: 130,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        "logout_message".tr(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Color.fromRGBO(244, 130, 34, 1),
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }

                          showAlertDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width / 1.7, 40),
                            backgroundColor: Color.fromRGBO(244, 130, 34, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/logout.png",
                              width: 20,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "log_out".tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 90,
                      ),
                      Text(
                        '${"app_version".tr()} $version.$buildNumber',
                        style: const TextStyle(
                            color: Color.fromRGBO(244, 130, 34, 1),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
