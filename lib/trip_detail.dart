import 'package:driver_app/commons.dart';
import 'package:driver_app/trip_track.dart';
import 'package:driver_app/widgets/trip_card.dart';
import 'package:driver_app/widgets/trip_detail_card.dart';
import 'package:driver_app/widgets/trip_detail_track.dart';
import 'package:driver_app/widgets/trip_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'widgets/constants.dart';
import 'widgets/ctm_painter.dart';
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

class TripDetail extends StatefulWidget {
  final dynamic trip;
  final String avatar_url;

  const TripDetail({Key? key, this.trip, required this.avatar_url})
      : super(key: key);

  @override
  State<TripDetail> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController4 = ScrollController();
  bool _isLoading = false;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TripInfo getInfoModel(TripStatus type) {
    return TripInfo(
      status: type,
      tripNo: widget.trip['id'],
      company: CompanyInfo(
        companyName: widget.trip['client_name'],
        tripName: widget.trip['trip_name'],
      ),
      busNo: widget.trip['bus_no'],
      passengers: widget.trip['bus_size_id'],
      busLine: BusLineInfo(
        fromTime: DateTime(
            Commons.getYear(widget.trip['start_date']),
            Commons.getMonth(widget.trip['start_date']),
            Commons.getDay(widget.trip['start_date']),
            Commons.getHour(widget.trip['start_time']),
            Commons.getMinute(widget.trip['start_time'])),
        toTime: DateTime(
            Commons.getYear(widget.trip['end_date']),
            Commons.getMonth(widget.trip['end_date']),
            Commons.getDay(widget.trip['end_date']),
            Commons.getHour(widget.trip['end_time']),
            Commons.getMinute(widget.trip['end_time'])),
        // courseName: "${widget.trip['origin_area']} - ${widget.trip['destination_area']}",
        // cityName: widget.trip['origin_city'],
        courseName: "${widget.trip['origin_area'] ?? 'here'} ",
        courseEndName: "${widget.trip['destination_area'] ?? 'here'} ",
        cityName: widget.trip['origin_city'] ?? "here",
        cityEndName: widget.trip['destination_city'] ?? "here",

        // courseName: "code here",
        // cityName: "code here",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final primaryTabBarHMargin = 150 * SizeConfig.scaleX;

    TripStatus tripStatus = TripStatus.pending;
    if (widget.trip['status'] == "1" || widget.trip['status'] == "0") {
      tripStatus = TripStatus.pending;
    } else if (widget.trip['status'] == "2") {
      //accept
      tripStatus = TripStatus.accepted;
    } else if (widget.trip['status'] == "3") {
      //reject
      tripStatus = TripStatus.rejected;
    } else if (widget.trip['status'] == "5") {
      //cancel
      tripStatus = TripStatus.canceled;
    } else if (widget.trip['status'] == "4") {
      //start
      tripStatus = TripStatus.started;
    } else if (widget.trip['status'] == "6") {
      //finish
      tripStatus = TripStatus.finished;
    } else if (widget.trip['status'] == "7") {
      //finish
      tripStatus = TripStatus.fake;
    }
    Future<void> _handleRefresh() async {
      setState(() {
        _isLoading = true; // Set isLoading to true while refreshing
      });

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false; // Set isLoading to false when data is loaded
      });
    }

    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              _tabController.index == 0 &&
              notification.metrics.pixels <= 0) {
            // call _handleRefresh when scroll position is at the top
            _handleRefresh();
          } else if (notification is ScrollUpdateNotification &&
              _tabController.index == 0 &&
              notification.metrics.pixels <= 0) {
            // call _handleRefresh when scroll position is at the top
            _handleRefresh();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SafeArea(
              child: Scaffold(
            body: Stack(children: [
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_trip.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: [
                      Row(
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
                      Container(
                        height: 100 * SizeConfig.scaleY,
                        width: 200,
                        margin: EdgeInsets.only(
                          left: primaryTabBarHMargin,
                          right: primaryTabBarHMargin,
                          top: 105 * SizeConfig.scaleY,
                        ),
                        decoration: BoxDecoration(
                          color: kColorPrimaryBlue,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: Color.fromRGBO(244, 130, 34, 1),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 40 * SizeConfig.scaleY,
                          ),
                          tabs: [
                            Tab(
                              text: "Details".tr(),
                            ),
                            Tab(
                              text: "Tracking".tr(),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: AbsorbPointer(
                              absorbing: _isLoading,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Container(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          TripDetailCard(
                                            info: getInfoModel(tripStatus),
                                            onPressed: () =>
                                                {print("card selected!")},
                                            trip: widget.trip,
                                            avatar_url: widget.avatar_url != ""
                                                ? widget.avatar_url
                                                : "http://167.86.102.230/alnabali/public/images/admin/client_default.png",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TripDetailTrack(
                                    trip_id: widget.trip["id"].toString(),
                                  )
                                ],
                              )))
                    ],
                  )),
              if (_isLoading)
                const Center(
                    child: SizedBox(
                  height: 100,
                  width: 100,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: _kDefaultRainbowColors,
                      strokeWidth: 4.0),
                )),
            ]),
          )),
        ));
  }
}
