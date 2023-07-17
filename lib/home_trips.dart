import 'package:driver_app/commons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';

class HomeTripsPage extends StatefulWidget {
  const HomeTripsPage({Key? key}) : super(key: key);

  @override
  State<HomeTripsPage> createState() => _HomeTripsPageState();
}

class _HomeTripsPageState extends State<HomeTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    Commons.isTrip = true;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final primaryTabBarHMargin = 150 * SizeConfig.scaleX;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg_notification.png"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                height: 130 * SizeConfig.scaleY,
                width: 270,
                margin: EdgeInsets.only(
                    left: primaryTabBarHMargin,
                    right: primaryTabBarHMargin,
                    top: 50 * SizeConfig.scaleY,
                    bottom: 10),
                decoration: BoxDecoration(
                  color: kColorThirtyGrey,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Color.fromRGBO(244, 130, 34, 1),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 40 * SizeConfig.scaleY,
                  ),
                  tabs: [
                    Tab(text: 'today_trips'.tr()),
                    Tab(text: 'past_trips'.tr()),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    // TODAY TRIPS view
                    TripsListView(
                        listType: TripsListType.todayTrips, today: true),

                    // PAST TRIPS view
                    TripsListView(
                        listType: TripsListType.pastTrips, today: false),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 100,
                      top: MediaQuery.of(context).size.height / 100),
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
                              start: MediaQuery.of(context).size.width * 0.11,
                              top: 20,
                              bottom: 15),
                          child: Image.asset("assets/navbar_track2.png"),
                        )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height,
                        // margin: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 7),
                        child: TextField(
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                              enabled: false,
                              prefixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, top: 10, bottom: 10),
                                // padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                                child: Image.asset(
                                  "assets/navbar_trip.png",
                                  color: Color.fromRGBO(244, 130, 34, 1),
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 1),
                              fillColor: Colors.white,
                              // contentPadding: EdgeInsets.all(1),
                              hintText: 'trips'.tr(),
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(244, 130, 34, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                        child: Container(
                            child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.0001,
                              top: 20,
                              bottom: 15),
                          child: Image.asset("assets/navbar_notification.png"),
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                            child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.1,
                              top: 20,
                              bottom: 15),
                          child: Image.asset("assets/navbar_user.png"),
                        )),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
