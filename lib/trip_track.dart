import 'dart:async';
import 'dart:convert';
import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/TripDialogDetail.dart';
import 'package:driver_app/widgets/trip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'widgets/ctm_painter.dart';

class TripTrack extends StatefulWidget {
  const TripTrack({Key? key}) : super(key: key);

  @override
  State<TripTrack> createState() => _TripTrackState();
}

class _TripTrackState extends State<TripTrack> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.335, -122.032);
  static const LatLng destLocation = LatLng(37.335, -122.070);

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polylineCoordinates = [];
  List<LocationData>? currentLocations;

  List<LatLng> latLen = [];

  String? driverCnt = null;

  Set<Marker> markers = Set();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  late Timer timer;
  Map<String, dynamic>? tripInfo;

  late String trip_name;
  late String origin_city;
  late String origin_area;
  late String dest_city;
  late String dest_area;

  late String latitude;
  late String longitude;

  late String? finalLatitude;
  late String? finalLongitude;

  Future<void> getCurrentLocations() async {
    List<dynamic>? list = null;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/alnabali/public/android/driver-location'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    list = responseJson["result"];
    developer.log("map" + list.toString());
    // setState(() {
    driverCnt = list!.length.toString();
    // });
    developer.log("map23" + driverCnt!);

    markers.add(
      Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
          icon: BitmapDescriptor.defaultMarker),
    );
    markers.add(
      Marker(
        markerId: MarkerId("destination"),
        position: destLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    developer.log("map234" + list.runtimeType.toString());

    list.asMap().forEach((key, element) {
      developer.log("map33" + "marker${element['trip_id']}");
      developer.log("map334 " + element['latitude']);
      developer.log("map335 " + element['longitude']);
      Marker marker = Marker(
          markerId: MarkerId("marker${element['trip_id']}"),
          position: LatLng(double.parse(element['latitude']),
              double.parse(element['longitude'])),
          icon: currentIcon,
          onTap: () {
            developer.log("markertap");
            getDialog();

            // getTrip(element['trip_id']);
          });
      // setState(() {
      markers.add(marker);
      // });
      developer.log("map338 " + markers.toString());
    });
  }

  Future<bool> getCoordinates(String address) async {
    dynamic locations = null;
    try {
      locations = await locationFromAddress(address, localeIdentifier: "en_US");
      finalLatitude = locations[0].latitude.toString();
      finalLongitude = locations[0].longitude.toString();
      developer.log("locationHello" + locations.toString());
      developer.log("mylocation222" + locations[0].latitude.toString());
      developer.log("mylocation223" + locations[0].longitude.toString());
      return true;
    } on Exception catch (e) {
      developer.log("locationHello333");
      return false;
    }
  }

  Future<void> getDialog() {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            child: SizedBox.expand(
                child: TripDialogDetail(
              trip_name: trip_name,
              origin_city: origin_city,
              origin_area: origin_area,
              dest_city: dest_city,
              dest_area: dest_area,
            )),
            margin: EdgeInsets.only(bottom: 0, left: 0, right: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  void getTrip(String trip_id) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/alnabali/public/android/daily-trip/${trip_id}'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    tripInfo = responseJson["result"];
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Commons.APIKEY,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destLocation.latitude, destLocation.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/bus_from.png")
        .then((icon) => currentIcon = icon);
  }

  @override
  void initState() {
    setCustomMarkerIcon();
    // getCurrentLocations();
    getPolyPoints();

    // timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => getCurrentLocations());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    trip_name = args[0];
    origin_city = args[1];
    origin_area = args[2];
    dest_city = args[3];
    dest_area = args[4];
    latitude = args[5];
    longitude = args[6];
    developer.log("kkkkkkkkk" + dest_city + dest_area);

    latLen.add(LatLng(double.parse(latitude), double.parse(longitude)));
    getCoordinates(dest_city + dest_area).then((value) {
      latLen.add(
          LatLng(double.parse(finalLatitude!), double.parse(finalLongitude!)));
      for (int i = 0; i < latLen.length; i++) {
        _markers.add(
            // added markers
            Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          icon: currentIcon,
        ));
        setState(() {});
        _polyline.add(Polyline(
          polylineId: PolylineId('1'),
          points: latLen,
          color: Colors.green,
        ));
      }
    });

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: Container(
              decoration: BoxDecoration(color: Colors.orange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 20,
                      height: 35,
                      margin: EdgeInsets.only(top: 30, left: 30),
                      child: CustomPaint(
                        painter: BackArrowPainter(),
                      ),
                    ),
                  ),
                  Text(
                    // "TRIP #12345",
                    trip_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 4),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                  )
                ],
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: FutureBuilder(
            future: getCurrentLocations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: Text("No Driver is running..."));
              }
              return GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(double.parse(latitude), double.parse(longitude)),
                    zoom: 13),
                polylines: _polyline,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            },
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: GestureDetector(
              onTap: () {
                getDialog();
              },
              child: Container(
                height: 300,
                child: SizedBox.expand(
                    child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.black45, width: 1)),
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
                                trip_name,
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 11,
                                    decoration: TextDecoration.none),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
                margin: EdgeInsets.only(bottom: 0, left: 0, right: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
      ],
    ));
  }
}
