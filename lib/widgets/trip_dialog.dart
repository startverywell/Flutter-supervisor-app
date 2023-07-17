import 'package:driver_app/commons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDialog extends StatefulWidget {
  final String driver_name;
  final String trip_name;
  final String origin_city;
  final String origin_area;
  final String dest_city;
  final String dest_area;

  final String latitude;
  final String longitude;

  const TripDialog(
      {Key? key,
      required this.driver_name,
      required this.trip_name,
      required this.origin_city,
      required this.origin_area,
      required this.dest_city,
      required this.dest_area,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  _TripDialogState createState() => _TripDialogState();
}

class _TripDialogState extends State<TripDialog> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _makingPhoneCall() async {
    var url = Uri.parse("tel:123456789");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 330,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectionArea(
                    child: Text(
                  // 'Sufian Abu Alabban',
                  widget.driver_name,
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                      decoration: TextDecoration.none),
                )),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black45, width: 1)),
                  child: Image.asset(
                    'assets/images/company_amazon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectionArea(
                        child: Text(
                      ' ',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          decoration: TextDecoration.none),
                    )),
                    SelectionArea(
                        child: Text(
                      // 'Amazon Morning Trip',
                      widget.trip_name,
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                          decoration: TextDecoration.none),
                    )),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.black45,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/bus_from.png',
                          width: 60,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                        Image.asset(
                          'assets/images/bus_to.png',
                          width: 25,
                          height: 25,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Divider(color: Colors.orange, thickness: 1, height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                                child: Text(
                              'Origin Location',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.orange,
                                  decoration: TextDecoration.none),
                            )),
                            SelectionArea(
                                child: Text(
                              // 'Khalda - Alnaymat St.',
                              widget.origin_city + " - " + widget.origin_area,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black45,
                                  decoration: TextDecoration.none),
                            )),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SelectionArea(
                                child: Text(
                              'Destination Location',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.orange,
                                  decoration: TextDecoration.none),
                            )),
                            SelectionArea(
                                child: Text(
                              // 'Khalda - Alnaymat St.',
                              widget.dest_city + " - " + widget.dest_area,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black45,
                                  decoration: TextDecoration.none),
                            )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                                child: Text(
                              'Distance',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.orange,
                                  decoration: TextDecoration.none),
                            )),
                            SelectionArea(
                                child: Text(
                              '40Km',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  decoration: TextDecoration.none),
                            )),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                                child: Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.orange,
                                  decoration: TextDecoration.none),
                            )),
                            SelectionArea(
                                child: Text(
                              '15min',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  decoration: TextDecoration.none),
                            )),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                                child: Text(
                              'Est. Time to Finish',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.orange,
                                  decoration: TextDecoration.none),
                            )),
                            SelectionArea(
                                child: Text(
                              '3min',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  decoration: TextDecoration.none),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black45,
              height: 0,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/trip_track", arguments: [
                        widget.trip_name,
                        widget.origin_city,
                        widget.origin_area,
                        widget.dest_city,
                        widget.dest_area,
                        widget.latitude,
                        widget.longitude
                      ]);
                    },
                    child: Container(
                      width: 120,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(width: 10,),
                          Image.asset(
                            "assets/navbar_track2.png",
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "TRIP TRACKING",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => _makingPhoneCall(),
                    child: Container(
                      width: 120,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(width: 10,),
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "CALL DRIVER",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
