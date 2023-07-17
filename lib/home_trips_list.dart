import 'dart:async';

import 'package:driver_app/commons.dart';
import 'package:driver_app/trip_detail.dart';
import 'package:driver_app/widgets/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/trip_card.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

enum TripsListType {
  todayTrips,
  pastTrips,
}

class TripsListView extends StatefulWidget {
  final TripsListType listType;
  final int selectedIndex;
  final bool today;

  const TripsListView({
    Key? key,
    required this.listType,
    this.selectedIndex = 0,
    required this.today,
  }) : super(key: key);

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  List<dynamic>? trips;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();
  final ScrollController _scrollController4 = ScrollController();
  final ScrollController _scrollController5 = ScrollController();
  final searchController = TextEditingController();
  // String get searchValue => searchController.text;
  // var marea = {};
  // var mcity = {};
  String searchValue = "";
  final _node = FocusScopeNode();

  void _searchEditingComplete() {
    if (searchValue != "") {
      // Your logic here
      setState(() {}); // This will rebuild the widget
    }
  }

  @override
  void initState() {
    Commons.isTrip = false;
    getTrips(true);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    _scrollController2.addListener(() {
      if (_scrollController2.position.pixels ==
          _scrollController2.position.maxScrollExtent) {}
    });
    _scrollController3.addListener(() {
      if (_scrollController3.position.pixels ==
          _scrollController3.position.maxScrollExtent) {}
    });
    _scrollController4.addListener(() {
      if (_scrollController4.position.pixels ==
          _scrollController4.position.maxScrollExtent) {}
    });
    _scrollController5.addListener(() {
      if (_scrollController5.position.pixels ==
          _scrollController5.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _node.dispose();
    searchController.dispose();
    super.dispose();
  }

  getCity() async {
    List<dynamic> cities;

    String url = "${Commons.baseUrl}city/";

    var response = await http.get(
      Uri.parse(url!),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      cities = responseJson['city'];

      cities.forEach((city) {
        Commons.mcity[city['id']] = city['city_name_en'];
      });
    }
    // return http.get(Uri.parse(url!),);
  }

  getArea() async {
    List<dynamic> cities;

    String url = "${Commons.baseUrl}area";

    var response = await http.get(
      Uri.parse(url!),
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      cities = responseJson['area'];
      cities.forEach((city) {
        Commons.marea[city['id']] = city['area_name_en'];
      });
    }
  }

  getTrips(bool today) async {
    // setToken();
    Map data = {
      'driver_name': "all",
      'supervisor': Commons.login_id,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      "Connection": "Keep-Alive",
      'Cookie': Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN': Commons.token
    };

    String? url = null;
    if (today) {
      url = "${Commons.baseUrl}daily-trip/today";
    } else {
      url = "${Commons.baseUrl}daily-trip/last";
    }
    var response =
        await http.post(Uri.parse(url!), body: data, headers: requestHeaders);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      trips = responseJson['result'];
    } else {
      Fluttertoast.showToast(
          msg: "Server Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0);
    }
  }

  TripInfo getInfoModel(TripStatus type, dynamic trip) {
    return TripInfo(
      status: type,
      tripNo: trip['id'],
      company: CompanyInfo(
        companyName: trip['client_name'],
        tripName: trip['trip_name'],
      ),
      busNo: trip['bus_no'],
      passengers: trip['bus_size_id'],
      busLine: BusLineInfo(
        fromTime: DateTime(
            Commons.getYear(trip['start_date']),
            Commons.getMonth(trip['start_date']),
            Commons.getDay(trip['start_date']),
            Commons.getHour(trip['start_time']),
            Commons.getMinute(trip['start_time'])),
        toTime: DateTime(
            Commons.getYear(trip['end_date']),
            Commons.getMonth(trip['end_date']),
            Commons.getDay(trip['end_date']),
            Commons.getHour(trip['end_time']),
            Commons.getMinute(trip['end_time'])),
        courseName: "${trip['origin_area'] ?? 'here'} ",
        courseEndName: "${trip['destination_area'] ?? 'here'} ",
        cityEndName: trip['destination_city'] ?? "here",
        cityName: trip['origin_city'] ?? "here",
      ),
    );
  }

  Widget displayTrips(String type) {
    List<Widget> list = <Widget>[];

    trips?.asMap().forEach((key, trip) {
      if (searchValue == "") {
        if (trip['status'] == "1" || trip['status'] == "0") {
          list.add(TripCard(
              past: true,
              info: getInfoModel(TripStatus.pending, trip),
              trip: trip,
              onPressed: () {}));
        } else if (trip['status'] == "2") {
          //accept
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.accepted, trip),
              onPressed: () {}));
        } else if (trip['status'] == "3") {
          //reject
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.rejected, trip),
              onPressed: () {}));
        } else if (trip['status'] == "5") {
          //cancel
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.canceled, trip),
              onPressed: () {}));
        } else if (trip['status'] == "4") {
          //start
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.started, trip),
              onPressed: () {}));
        } else if (trip['status'] == "6") {
          //finish
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.finished, trip),
              onPressed: () {}));
        } else if (trip['status'] == "7") {
          //fake
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.fake, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 15),
        );
      }
      if (trip['bus_no'].contains(searchValue) ||
          trip['trip_name'].contains(searchValue) ||
          trip['client_name'].contains(searchValue) ||
          trip['dirver_name'].contains(searchValue)) {
        if (trip['status'] == "1" || trip['status'] == "0") {
          list.add(TripCard(
              past: true,
              info: getInfoModel(TripStatus.pending, trip),
              trip: trip,
              onPressed: () {}));
        } else if (trip['status'] == "2") {
          //accept
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.accepted, trip),
              onPressed: () {}));
        } else if (trip['status'] == "3") {
          //reject
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.rejected, trip),
              onPressed: () {}));
        } else if (trip['status'] == "5") {
          //cancel
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.canceled, trip),
              onPressed: () {}));
        } else if (trip['status'] == "4") {
          //start
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.started, trip),
              onPressed: () {}));
        } else if (trip['status'] == "6") {
          //finish
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.finished, trip),
              onPressed: () {}));
        } else if (trip['status'] == "7") {
          //fake
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.fake, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 15),
        );
      }
    });
    if (trips?.length == 0) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20),
          child: Text(
            "No data to display",
            style: TextStyle(fontSize: 15, color: Colors.deepOrange),
          ));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: list);
  }

  Widget displaySubTrips(String type) {
    List<Widget> list = <Widget>[];

    trips?.asMap().forEach((key, trip) {
      if (type == "pending") {
        if (trip['status'] == "1" || trip['status'] == "0") {
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.pending, trip),
              onPressed: () {
                TripDetail(
                  trip: trip,
                  avatar_url: "",
                );
              }));
        }
        list.add(
          const SizedBox(height: 20),
        );
      } else if (type == "accept") {
        if (trip['status'] == "2") {
          //accept
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.accepted, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 20),
        );
      } else if (type == "reject") {
        if (trip['status'] == "3") {
          //reject
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.rejected, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 20),
        );
      } else if (type == "cancel") {
        if (trip['status'] == "5") {
          //cancel
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.canceled, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 20),
        );
      } else if (type == "start") {
        if (trip['status'] == "4") {
          //start
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.started, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 20),
        );
      } else if (type == "finish") {
        if (trip['status'] == "6") {
          //finish
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.finished, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 1),
        );
      } else if (type == "fake") {
        if (trip['status'] == "7") {
          //fake
          list.add(TripCard(
              past: true,
              trip: trip,
              info: getInfoModel(TripStatus.fake, trip),
              onPressed: () {}));
        }
        list.add(
          const SizedBox(height: 15),
        );
      }
    });
    if (trips?.length == 0) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 30),
          child: Text(
            "No data to display",
            style: TextStyle(fontSize: 15, color: Colors.deepOrange),
          ));
    }
    return Column(children: list);
  }

  RefreshIndicator getTab(String type) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.today ? getTrips(true) : getTrips(false);
        setState(() {});
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          // TripCard( past: true,info: testStarted, onPressed: () {}),
          // const SizedBox(height: 20),
          // TripCard( past: true,info: testStarted, onPressed: () {}),
          FutureBuilder<List<void>>(
            future: Future.wait([
              widget.today ? getTrips(true) : getTrips(false),
              getArea(),
              getCity()
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<void>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: _kDefaultRainbowColors,
                      strokeWidth: 4.0),
                );
              } else {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text(
                        'A system error has occurred.',
                        style: TextStyle(color: Colors.red, fontSize: 32),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return displaySubTrips(type);
              }
            },
          )
        ]),
      ),
    );
  }

  String _getTabTextFromID(int id) {
    if (id == 100) {
      return 'all'.tr();
    } else {
      return "${kTripStatusStrings[id]}".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    getCity();
    getArea();
    getTrips(true);

    SizeConfig().init(context);

    List<int> tabIDArray = [100, 1, 2, 3, 4, 5, 6, 7];
    Map<String, List<dynamic>> grouped = {};
    var tabCount = 8;
    if (widget.listType == TripsListType.pastTrips) {
      tabIDArray = [100, 5, 6, 7];
      tabCount = 4;
    }

    return DefaultTabController(
      length: tabCount,
      child: Column(
        children: <Widget>[
          widget.listType == TripsListType.pastTrips
              ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SingleChildScrollView(
                    controller: _scrollController2,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 10, bottom: 10, top: 10, right: 3),
                          height: 61 * SizeConfig.scaleY,
                          child: Image.asset('assets/images/home_icon2.png'),
                        ),
                        ButtonsTabBar(
                          backgroundColor: kColorPrimaryBlue,
                          borderColor: kColorPrimaryBlue,
                          unselectedBackgroundColor: Colors.transparent,
                          unselectedBorderColor: const Color(0xFFB3B3B3),
                          borderWidth: 1,
                          height: 32,
                          radius: 100,
                          // contentPadding: EdgeInsets.only(right: 3),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 38 * SizeConfig.scaleX),
                          labelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFFB3B3B3),
                          ),
                          tabs: tabIDArray
                              .map(
                                (t) => Tab(
                                  text: _getTabTextFromID(t),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ])
              : SingleChildScrollView(
                  controller: _scrollController3,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, bottom: 10, top: 10, right: 3),
                        height: 61 * SizeConfig.scaleY,
                        child: Image.asset('assets/images/home_icon2.png'),
                      ),
                      ButtonsTabBar(
                        backgroundColor: kColorPrimaryBlue,
                        unselectedBackgroundColor: Colors.transparent,
                        borderColor: kColorPrimaryBlue,
                        unselectedBorderColor: const Color(0xFFB3B3B3),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 38 * SizeConfig.scaleX),
                        borderWidth: 1,
                        height: 32,
                        radius: 100,
                        //height: 62 * SizeConfig.scaleX,
                        // contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                        labelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Color.fromARGB(255, 92, 91, 91),
                        ),
                        tabs: tabIDArray
                            .map((t) => Tab(text: _getTabTextFromID(t)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 350,
            height: 40,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
                _searchEditingComplete(); // Call the function on every change
              },
              onEditingComplete: () => _searchEditingComplete(),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr(),
                labelStyle: const TextStyle(
                    fontSize: 12,
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
                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async {
                    widget.today ? getTrips(true) : getTrips(false);
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController4,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // TripCard( past: true,info: testStarted, onPressed: () {}),
                          // const SizedBox(height: 20),
                          // TripCard( past: true,info: testStarted, onPressed: () {}),
                          FutureBuilder<List<void>>(
                            future: Future.wait([
                              widget.today ? getTrips(true) : getTrips(false),
                              getArea(),
                              getCity()
                            ]),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<void>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                debugPrint("ConnectionState.waiting");
                                return Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0.0, top: 120),
                                              child: const Center(
                                                  child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: LoadingIndicator(
                                                    indicatorType: Indicator
                                                        .ballRotateChase,
                                                    colors:
                                                        _kDefaultRainbowColors,
                                                    strokeWidth: 4.0),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                // return const Center(
                                //     child: SizedBox(
                                //   height: 100,
                                //   width: 100,
                                //   child: LoadingIndicator(
                                //       indicatorType: Indicator.ballRotateChase,
                                //       colors: _kDefaultRainbowColors,
                                //       strokeWidth: 4.0),
                                // ));
                              } else {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'A system error has occurred.',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 32),
                                    ),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  debugPrint(
                                      "! snapshot . hasData ${!snapshot.hasData}");
                                  return CircularProgressIndicator();
                                }
                                return displayTrips("all");
                              }
                            },
                          )
                        ]),
                  ),
                ),
                if (widget.today)
                  RefreshIndicator(
                    onRefresh: () async {
                      widget.today ? getTrips(true) : getTrips(false);
                      setState(() {});
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController5,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        // TripCard( past: true,info: testStarted, onPressed: () {}),
                        // const SizedBox(height: 20),
                        // TripCard( past: true,info: testStarted, onPressed: () {}),
                        FutureBuilder<List<void>>(
                          future: Future.wait([
                            widget.today ? getTrips(true) : getTrips(false),
                            getArea(),
                            getCity()
                          ]),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<void>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              debugPrint("ConnectionState.waiting");
                              return const SizedBox(
                                height: 100,
                                width: 100,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballRotateChase,
                                    colors: _kDefaultRainbowColors,
                                    strokeWidth: 4.0),
                              );
                            } else {
                              if (snapshot.hasError) {
                                return Scaffold(
                                  body: Center(
                                    child: Text(
                                      'A system error has occurred.',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 32),
                                    ),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                debugPrint(
                                    "! snapshot . hasData ${!snapshot.hasData}");
                                return LoadingIndicator(
                                    indicatorType: Indicator.ballRotateChase,
                                    colors: _kDefaultRainbowColors,
                                    strokeWidth: 4.0);
                              }
                              return displaySubTrips("pending");
                            }
                          },
                        )
                      ]),
                    ),
                  ),
                if (widget.today) getTab("accept"),
                if (widget.today) getTab("reject"),
                if (widget.today) getTab("start"),
                getTab("cancel"),
                getTab("finish"),
                getTab("fake"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
