import 'dart:io';

import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/ctm_painter.dart';
import 'package:driver_app/widgets/input_edit_field.dart';
import 'package:driver_app/widgets/input_text_area.dart';
import 'package:driver_app/widgets/input_text_area_ar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/input_edit_field_ar.dart';
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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String userProfileImage = "";
  String? userName;
  late String name, phone, birthday, address;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController birthController1 = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _image;

  Future<bool?> arabicMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("isArabic");
  }

  Future<void> pickImage() async {
    // final XFile? pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile == null) return;
    // final File image = File(pickedFile.path);
    // setState(() {
    //   _image = image;
    // });
    // if (_image != null) {
    //   uploadImage();
    // }

    Widget cancelButton = TextButton(
      child: Text("update".tr()),
      onPressed: () {
        UpdateImage();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("remove".tr()),
      onPressed: () {
        Navigator.pop(context);
        RemoveImage();
        setState(() {
          userProfileImage = "";
        });
      },
    );
    Widget endButton = TextButton(
      child: Text("cancel".tr()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("notice".tr()),
      content: Text("notice_content".tr()),
      actions: [
        cancelButton,
        continueButton,
        endButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String? avaImg;

  Future<void> UpdateImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      avaImg = pickedFile.path.split('/').last;
      uploadImage(avaImg);
    }
  }

  Future<void> uploadImage(avaImg) async {
    String uploadUrl = "${Commons.baseUrl}supervisor/upload/image";

    try {
      List<int> imageBytes = _image!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      Map data = {
        'id': Commons.login_id,
        'image': baseimage,
        'image_name': avaImg
      };

      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Cookie': Commons.cookie,
        'X-CSRF-TOKEN': Commons.token
      };
      var response = await http.post(Uri.parse(uploadUrl),
          headers: requestHeaders, body: data);

      // convert file image to Base64 encoding
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        print(jsondata['result']);
        if (jsondata["result"] == "success") {
          //check error sent from server
          Commons.showSuccessMessage("Upload successful");
          //if error return from server, show message from server
        } else {
          Commons.showSuccessMessage("Upload successful");
        }
      } else {
        Commons.showErrorMessage("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      Commons.showSuccessMessage("Upload successful");
      //there is error during converting file image to base64 encoding.
    }
  }

  Future<void> RemoveImage() async {
    String uploadUrl = "${Commons.baseUrl}supervisor/upload_remove/image";
    print(uploadUrl);
    try {
      Map data = {
        'id': Commons.login_id,
      };

      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Cookie': Commons.cookie,
        'X-CSRF-TOKEN': Commons.token
      };
      var response = await http.post(Uri.parse(uploadUrl),
          headers: requestHeaders, body: data);

      // convert file image to Base64 encoding
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["result"] == "success") {
          //check error sent from server
          Commons.showSuccessMessage("Remove successful");
          //if error return from server, show message from server
        } else {
          Commons.showErrorMessage(jsondata["result"]);
        }
      } else {
        Commons.showErrorMessage("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      Commons.showSuccessMessage("Remove successful");
      //there is error during converting file image to base64 encoding.
    }
  }

  getUserData() async {
    // requestHeaders['cookie'] = Commons.cookie;
    print("-----------------------------------------------");
    String url = "${Commons.baseUrl}supervisor/profile/${Commons.login_id}";
    var response = await http.get(Uri.parse(url));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var user = responseJson['driver'];
      setState(() {
        userName = user['name'];
        name = user['name'];
        phone = user['phone'];
        birthday = user['birthday'];
        address = user['address'];
        nameController.text = user['name'];
        phoneController.text = user['phone'];
        addressController.text = user['address'] ?? " ";
        String datee = user['birthday'];
        List<String> substrings = datee.split("-");

        birthController1.text =
            substrings[2] + "/" + substrings[1] + "/" + substrings[0];

        birthController.text = user['birthday'];
      });

      if (user['profile_image'] != null) {
        if (userProfileImage != "") return;
        setState(() {
          userProfileImage = user['profile_image'];
          name = user['name'];
          // phone = user['phone'];
          // address = user['address'];
          // birthday = user['birthday'];
        });
      }
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  updateProfile() async {
    Map data = {
      'id': Commons.login_id,
      'name': nameController.text,
      'birthday': birthController.text,
      'phone': phoneController.text,
      'address': addressController.text,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      'X-CSRF-TOKEN': Commons.token
    };
    String url = "${Commons.baseUrl}supervisor/profile_edit";
    var response =
        await http.post(Uri.parse(url), headers: requestHeaders, body: data);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    print(responseJson['result']);
    if (response.statusCode == 200) {
      if (responseJson['result'] == 'success') {
        Commons.showSuccessMessage("Update Successfully.");
        Navigator.pushNamed(context, "/profile");
      } else if (responseJson['result'] == "Invalid input data") {
        Commons.showErrorMessage("Input Your Information");
      }
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

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
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            getUserData();
          },
          child: SingleChildScrollView(
              child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_editpro.png"),
                        alignment: Alignment.topCenter)),
                height: MediaQuery.of(context).size.height / 2,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 20,
                                height: 40,
                                margin: context.locale == Locale('en', 'UK')
                                    ? EdgeInsets.only(top: 20, left: 30)
                                    : EdgeInsets.only(top: 20, right: 30),
                                child: CustomPaint(
                                  painter: BackArrowPainter(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              top: MediaQuery.of(context).size.height / 35),
                          child: Text(
                            "edit_profile1".tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 8,
                        )
                      ],
                    ),
                    GestureDetector(
                      //                onTap: () {
                      //   pickImage();
                      // },
                      child: _image == null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsetsDirectional.only(
                                      top: MediaQuery.of(context).size.height /
                                          10),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userProfileImage),
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  244, 130, 34, 1)),
                                          borderRadius:
                                              BorderRadius.circular(55)),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 100, top: 130),
                                    child: GestureDetector(
                                      onTap: () {
                                        pickImage(); // replace "yourFunction" with the actual function name
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            "assets/pending_icon.png"),
                                        width: 55,
                                        height: 55,
                                      ),
                                    )),
                              ],
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsetsDirectional.only(
                                      top: MediaQuery.of(context).size.height /
                                          15),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(_image!.path)),
                                    radius: 55,
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(left: 100, top: 130),
                                    child: GestureDetector(
                                      onTap: () {
                                        pickImage(); // replace "yourFunction" with the actual function name
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            "assets/pending_icon.png"),
                                        width: 55,
                                        height: 55,
                                      ),
                                    )),
                              ],
                            ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 10),
                      child: Text(
                        userName ?? 'unknown',
                        style: TextStyle(
                            color: Color.fromRGBO(244, 130, 34, 1),
                            fontSize: MediaQuery.of(context).size.height / 50,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 17,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(
                          start: MediaQuery.of(context).size.width / 5,
                          end: MediaQuery.of(context).size.width / 5),
                      child: context.locale == Locale('en', 'UK')
                          ? EditInputField(
                              displayName: "Name", myController: nameController)
                          : EditInputFieldAR(
                              displayName: "Name",
                              myController: nameController),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(
                          start: MediaQuery.of(context).size.width / 5,
                          end: MediaQuery.of(context).size.width / 5),
                      child: context.locale == Locale('en', 'UK')
                          ? EditInputField(
                              displayName: "Phone",
                              myController: phoneController)
                          : EditInputFieldAR(
                              displayName: "Phone",
                              myController: phoneController),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(
                          start: MediaQuery.of(context).size.width / 5,
                          end: MediaQuery.of(context).size.width / 5),
                      child: context.locale == Locale('en', 'UK')
                          ? EditInputField(
                              displayName: "Date of Birth",
                              myController: birthController1)
                          : EditInputFieldAR(
                              displayName: "Date of Birth",
                              myController: birthController1),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(
                          start: MediaQuery.of(context).size.width / 5,
                          end: MediaQuery.of(context).size.width / 5),
                      child: context.locale == Locale('en', 'UK')
                          ? InputTextArea(
                              displayName: "Address",
                              myController: addressController)
                          : InputTextAreaAR(
                              displayName: "Address",
                              myController: addressController),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width / 1.7, 30),
                          backgroundColor: Color.fromRGBO(244, 130, 34, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "save".tr(),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
