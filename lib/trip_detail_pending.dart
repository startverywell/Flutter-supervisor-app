import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/service/fcm_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'commons.dart';
import 'widgets/ctm_painter.dart';
import 'package:http/http.dart' as http;
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

enum SingingCharacter { notChange, pending, cancel, fake }

class TripDetailPending extends StatefulWidget {
  final dynamic trip;

  const TripDetailPending({Key? key, this.trip}) : super(key: key);

  @override
  State<TripDetailPending> createState() => _TripDetailPendingState();
}

class _TripDetailPendingState extends State<TripDetailPending>
    with SingleTickerProviderStateMixin {
  List<String> status = [
    "",
    "Pending",
    "Accept",
    "Reject",
    "Start",
    "Cancel",
    "Finish",
    "Fake"
  ];

  List<String> list = <String>['Pending', 'Cancel', 'Reject', 'Fake'];
  final List<String> busSizeList = <String>["Select Bus Size"];
  final List<String> busNoList = <String>["Select Bus No."];
  final List<String> driverList = <String>["Select Driver"];
  List<dynamic> driverList_ids = <String>["Select Driver"];

  List<dynamic> driver = [];
  List<dynamic> bus = [];
  List<dynamic> busSize = [];

  String busSizeValue = "Select Bus Size";
  String busNoValue = "Select Bus No.";
  String driverValue = "Select Driver";

  SingingCharacter? _character = SingingCharacter.notChange;

  @override
  void initState() {
    getDriver();
    getBusSize();
    getBus();
    super.initState();
  }

  getDriver() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/alnabali/public/android/driver/all'),
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    driver = responseJson["result"];

    driverList.clear();
    driverList.add("Select Driver");
    driverList_ids.clear();
    driverList_ids.add("Select Driver");
    for (int i = 0; i < driver.length; i++) {
      driverList.add(driver[i]['name_en'].toString());
      driverList_ids.add(driver[i]['id'].toString());
    }
  }

  getBusSize() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/alnabali/public/android/bussize/all'),
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    busSize = responseJson["result"];
    busSizeList.clear();
    busSizeList.add("Select Bus Size");
    for (int i = 0; i < busSize.length; i++) {
      busSizeList.add(busSize[i]['size'].toString());
    }
  }

  getBus() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/alnabali/public/android/bus/all'),
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    bus = responseJson["result"];

    busNoList.clear();
    busNoList.add("Select Bus No.");
    for (int i = 0; i < bus.length; i++) {
      busNoList.add(bus[i]['bus_no'].toString());
    }
  }

  Future<bool> editDailyTrip(String status) async {
    Map data = {
      'id': widget.trip['id'].toString(),
      'status': status,
      'bus_size': busSizeValue,
      'bus': busNoValue,
      'driver': driverValue,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN': Commons.token
    };

    String url = "${Commons.baseUrl}daily-trip/edit";
    var response =
        await http.post(Uri.parse(url), body: data, headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseJson['result'] == "success") {
        Commons.showSuccessMessage("Changed Successfully!");
        return true;
      }
    }
    return false;
  }

  sendFCMMessage() async {
    // String body = widget.trip['id'].toString() +
    //     ": " +
    //     widget.trip['trip_name'].toString();
    // String title =
    //     "Trip was changed from ${widget.trip["dirver_name"]} to driver $driverValue";
    // FCMService.sendPushMessage(Commons.fcm_token, body, title);
    // print("notification" + Commons.fcm_token);
    //
    // String id = widget.trip['driver_id'];
    // DocumentSnapshot snap = await FirebaseFirestore.instance
    //     .collection("UserTokens")
    //     .doc('driver$id')
    //     .get();
    // try {
    //   String driverToken = snap['token'];
    //   FCMService.sendPushMessage(driverToken, body, title);
    // } catch (e) {
    //   print("pushmessage" + e.toString());
    // }
    //
    // print("drivervaluevalue" + driverValue);
    // print("drivervaluelist" + driverList.toString());
    //
    // int current_id = driverList.indexOf(driverValue);
    // current_id = int.parse(driverList_ids[current_id]);
    // DocumentSnapshot current_snap = await FirebaseFirestore.instance
    //     .collection("UserTokens")
    //     .doc('driver$current_id')
    //     .get();
    // try {
    //   String current_driverToken = current_snap['token'];
    //   FCMService.sendPushMessage(current_driverToken, body, title);
    // } catch (e) {
    //   print("pushmessage" + e.toString());
    // }

    Navigator.pushNamed(context, "/trip");
  }

  @override
  Widget build(BuildContext context) {
    num sHeight = MediaQuery.of(context).size.height;

    String dropdownValue = status[int.parse(widget.trip["status"])];
    if (_character == SingingCharacter.pending) {
      dropdownValue = "Pending";
    } else if (_character == SingingCharacter.fake) {
      dropdownValue = "Fake";
      driverValue = driverList.first;
      busNoValue = busNoList.first;
      busSizeValue = busSizeList.first;
    } else if (_character == SingingCharacter.cancel) {
      dropdownValue = "Cancel";
    } else if (_character == SingingCharacter.notChange) {
      driverValue = widget.trip["dirver_name"];
      busSizeValue = widget.trip["bus_size_id"].toString();
      busNoValue = widget.trip["bus_no"].toString();
    }

    return FutureBuilder<List<void>>(
      future: Future.wait([getDriver(), getBus(), getBusSize()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // driverList.clear();
          // busNoList.clear();
          // busSizeList.clear();

          // for (int i = 0; i < driver.length; i++) {
          //   driverList.add(driver[i]['name_en'].toString());
          // }
          // for (int i = 0; i < bus.length; i++) {
          //   busNoList.add(bus[i]['bus_no'].toString());
          // }
          // for (int i = 0; i < busSize.length; i++) {
          //   busSizeList.add(busSize[i]['size'].toString());
          // }

          return Scaffold(
              body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/bg_trip.png",
                        ),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 20,
                            height: 30,
                            margin: EdgeInsets.only(top: 15, left: 30),
                            child: CustomPaint(
                              painter: BackArrowPainter(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1, // Set flex to 1
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 30),
                            child: Align(
                              alignment:
                                  Alignment.center, // Align column to center
                              child: Column(
                                children: [
                                  Text(
                                    "${widget.trip['trip_name']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none),
                                  ),
                                  Text(
                                    "TRIP #${widget.trip['trip_id']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        decoration: TextDecoration.none),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sHeight / 15,
                    ),
                    Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.2,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black38, blurRadius: 30)
                              ]),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Status",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  // value: dropdownValue,
                                  isExpanded: true,
                                  buttonHeight: 30,
                                  buttonDecoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      color: Colors.black26),
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.deepOrangeAccent,
                                    size: 30,
                                  ),
                                  style: const TextStyle(color: Colors.black54),
                                  disabledHint: Text(
                                    dropdownValue,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 11),
                                  ),
                                  // items: list.map<DropdownMenuItem<String>>(
                                  //         (String value) {
                                  //       return DropdownMenuItem<String>(
                                  //         child: Text(value, style: TextStyle(color: Colors.black54, fontSize: 11),),
                                  //         value: value,
                                  //       );
                                  //     }
                                  // ).toList(),
                                  items: [],
                                  // onChanged: (String? value) {
                                  //   setState(() {
                                  //     dropdownValue = value!;
                                  //   });
                                  // }
                                  onChanged: null,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emergency,
                                        color: Colors.red,
                                        size: 7,
                                      ),
                                      Text(
                                        "CHANGE STATUS",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: sHeight / 30,
                                    child: ListTile(
                                      horizontalTitleGap: -5,
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: 0),
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text('Don\'t Change',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black45)),
                                      leading: Radio<SingingCharacter>(
                                        activeColor: Colors.deepOrangeAccent,
                                        value: SingingCharacter.notChange,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sHeight / 30,
                                    child: ListTile(
                                      horizontalTitleGap: -5,
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text('Set as Pending',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black45)),
                                      leading: Radio<SingingCharacter>(
                                        activeColor: Colors.deepOrangeAccent,
                                        value: SingingCharacter.pending,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sHeight / 30,
                                    child: ListTile(
                                      horizontalTitleGap: -5,
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text('Set as Canceled',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black45)),
                                      leading: Radio<SingingCharacter>(
                                        activeColor: Colors.deepOrangeAccent,
                                        value: SingingCharacter.cancel,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sHeight / 30,
                                    child: ListTile(
                                      horizontalTitleGap: -5,
                                      contentPadding: EdgeInsets.all(0),
                                      title: const Text('Set as Fake',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black45)),
                                      leading: Radio<SingingCharacter>(
                                        activeColor: Colors.deepOrangeAccent,
                                        value: SingingCharacter.fake,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: sHeight / 30, bottom: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emergency,
                                        color: Colors.red,
                                        size: 7,
                                      ),
                                      Text(
                                        "BUS SIZE",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  value: busSizeValue,
                                  isExpanded: true,
                                  buttonHeight: sHeight / 22,
                                  buttonDecoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      color: Colors.transparent),
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.deepOrangeAccent,
                                    size: 30,
                                  ),
                                  style: const TextStyle(color: Colors.black54),
                                  disabledHint: Text(
                                    "Select Size",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 11),
                                  ),
                                  items: busSizeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11),
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (_character != SingingCharacter.fake) {
                                      setState(() {
                                        busSizeValue = value!;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: sHeight / 55, bottom: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emergency,
                                        color: Colors.red,
                                        size: 7,
                                      ),
                                      Text(
                                        "BUS NO.",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                    value: busNoValue,
                                    isExpanded: true,
                                    buttonHeight: sHeight / 22,
                                    buttonDecoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        color: Colors.transparent),
                                    iconSize: 20,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.deepOrangeAccent,
                                      size: 30,
                                    ),
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    disabledHint: Text(
                                      "Select Bus No.",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 11),
                                    ),
                                    items: busNoList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 11),
                                        ),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (_character != SingingCharacter.fake) {
                                        setState(() {
                                          busNoValue = value!;
                                        });
                                      }
                                    }),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: sHeight / 50, bottom: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emergency,
                                        color: Colors.red,
                                        size: 7,
                                      ),
                                      Text(
                                        "DRIVER",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                    value: driverValue,
                                    isExpanded: true,
                                    buttonHeight: sHeight / 22,
                                    buttonDecoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        color: Colors.transparent),
                                    iconSize: 20,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.deepOrangeAccent,
                                      size: 30,
                                    ),
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    disabledHint: Text(
                                      "Select Driver",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 11),
                                    ),
                                    items: driverList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 11),
                                        ),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (_character != SingingCharacter.fake) {
                                        setState(() {
                                          driverValue = value!;
                                        });
                                      }
                                    }),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "DETAILS",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Container(
                                width: double.infinity,
                                height: sHeight / 13,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26)),
                                child: Text(
                                  widget.trip["details"] ?? "No Detail",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black45),
                                ),
                              ),
                              SizedBox(
                                height: sHeight / 30,
                              ),
                              Center(
                                  child: OutlinedButton(
                                onPressed: () {
                                  // if (_character ==
                                  //     SingingCharacter.notChange) {
                                  //   Commons.showErrorMessage("Can't change!");
                                  //   return;
                                  // }
                                  editDailyTrip(dropdownValue).then((value) {
                                    if (value) {
                                      sendFCMMessage();
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    side: const BorderSide(
                                      color: Colors.orange,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width / 1.7,
                                        sHeight / 40),
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                10,
                                        top: 10,
                                        bottom: 10)),
                                child: Text(
                                  "save".tr(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                            ],
                          )),
                    ),
                  ],
                )),
          ));
        }
        return const Scaffold(
          body: Center(
              child: SizedBox(
            height: 100,
            width: 100,
            child: LoadingIndicator(
                // colors: [Colors.blue],
                // indicatorType: Indicator.ballClipRotate,
                // strokeWidth: 3,
                // ),
                indicatorType: Indicator.ballRotateChase,
                colors: _kDefaultRainbowColors,
                strokeWidth: 4.0),
          )),
        );
      },
    );
  }
}
