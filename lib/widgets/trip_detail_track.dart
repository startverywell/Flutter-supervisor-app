import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:http/http.dart' as http;

import '../commons.dart';
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

class TripDetailTrack extends StatefulWidget {
  final String trip_id;

  const TripDetailTrack({Key? key, required this.trip_id}) : super(key: key);

  @override
  State<TripDetailTrack> createState() => _TripDetailTrackState();
}

class _TripDetailTrackState extends State<TripDetailTrack>
    with SingleTickerProviderStateMixin {
  List<Widget> displayWidget = [];
  String newStatus = "Pending", oldStatus = "Pending";

  List<dynamic> transaction = [];
  Map<String, String> status = {
    "1": "pending",
    "2": "accepted",
    "3": "rejected",
    "4": "started",
    "5": "canceled",
    "6": "finished",
    "7": "fake",
    "100": "created"
  };
  bool isLoading = false;
  Future<List<dynamic>> getTransaction() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/alnabali/public/android/transaction/${widget.trip_id}'),
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    transaction = responseJson["result"];
    print("ffftransaction" + transaction.toString());
    setState(() {
      isLoading = false;
    });
    return transaction;
  }

  displayStatus(List<dynamic> trans) {
    List<Widget> list = [];
    trans.forEach((element) {
      list.add(rowStatus(status[element['new_status'].toString()].toString().tr()));
      list.add(Row(
        children: [
          const SizedBox(
            width: 40,
          ),
          Dash(
            direction: Axis.vertical,
            dashColor: Colors.red,
            dashLength: 5,
            length: 20,
          )
        ],
      ));
    });
    list.removeLast();
    setState(() {
      displayWidget = list;
    });
  }

  Widget rowStatus(String status) {
    if (status == "null") {
      status = "pending";
    }
    List<Widget> list = [];
    list.add(const SizedBox(
      width: 30,
    ));
    list.add(Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26, width: 2)),
          padding: EdgeInsetsDirectional.all(1),
          child: Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 10)]),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 10,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "Pending",

                      status.tr(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "trip_text ".tr() + status.tr(),
                      style: TextStyle(color: Colors.black45, fontSize: 10),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: MediaQuery
                //       .of(context)
                //       .size
                //       .width / 4,
                // ),
              ],
            )
          ],
        )
      ],
    ));
    Widget rowWidget = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Row(
              children: list,
            ),
          ),
          Text(
            "12:23" + "AM".tr(),
            style: TextStyle(
                color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold),
          )
        ]);
    return rowWidget;
  }

  @override
  void initState() {
    getTransaction().then((value) {
      setState(() {
        // newStatus = status[value[0]['new_status'].toString()]!;
        // oldStatus = status[value[0]['old_status'].toString()]!;
        displayStatus(value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: getTransaction,
            child: Center(
              heightFactor: 1.5,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 1.1,
                alignment: Alignment.center,
                child: ListView(
                  children: displayWidget,
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                child: Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: _kDefaultRainbowColors,
                      strokeWidth: 4.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
