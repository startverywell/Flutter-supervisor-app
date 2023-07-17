import 'dart:convert';

import 'package:driver_app/trip_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/trip_info.dart';
import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/trip_busline.dart';
import 'package:driver_app/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../commons.dart';

class TripCard extends StatefulWidget {
  final TripInfo info;
  final dynamic trip;
  final VoidCallback onPressed;
  final bool past;

  const TripCard({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.trip,
    required this.past,
  }) : super(key: key);

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  late String avatar = "";

  Future<String> getAvatar() async {
    String result = "";

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/alnabali/public/android/client/avatar/${widget.trip['client_name']}'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    result = responseJson["result"];

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    // getAvatar().then((value) {
    //   setState(() {
    //     avatar = value;
    //   });
    // });
    setState(() {
      avatar = widget.trip['client_avatar'];
      if (avatar == "http://167.86.102.230/alnabali/public/uploads/image/") {
        avatar =
            "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
      }
    });

    super.initState();
  }

  Widget _buildCompanyRow() {
    final screenW = MediaQuery.of(context).size.width;
    final avatarRadius = screenW * 0.0924 * 0.55;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.transparent,
            // backgroundImage: AssetImage(widget.info.company.getCompanyImgPath()),
            backgroundImage: NetworkImage(avatar),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.info.company.companyName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.company.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Color.fromRGBO(244, 130, 34, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "bus_no".tr(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 8,
                color: Colors.orange,
              ),
            ),
            Text(
              widget.info.busNo,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
             Padding(
              padding: EdgeInsets.only(top: 3),
              //apply padding to some sides only
              child: Text(
                'passenger'.tr(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 8,
                  color: Colors.orange,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenW * 0.035,
                  child: Image.asset(
                    'assets/images/passengers.png',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.info.passengers.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    if (widget.info.status == TripStatus.pending ||
        widget.info.status == TripStatus.accepted ||
        widget.info.status == TripStatus.started) {
      final screenW = MediaQuery.of(context).size.width;
      final btnW = screenW * 0.24;
      final btnH = btnW * 0.25;
      final yesTitle =
          widget.info.status == TripStatus.started ? 'FINISH' : 'ACCEPT';
      final noTitle =
          widget.info.status == TripStatus.started ? 'NAVIGATION' : 'REJECT';

      return SizedBox(
        height: btnH + 34,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: btnW,
              height: btnH,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimaryBlue,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  yesTitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            GradientButton(
              width: btnW,
              height: btnH,
              onPressed: () {},
              title: noTitle,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(height: 36);
    }
  }

  Widget _buildCardContents() {
    final screenW = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenW * 0.364,
              child: Image.asset(widget.info.getStatusImgPath()),
            ),
            Text(
              widget.info.getStatusStr().tr(),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // !widget.past
        //     ? Padding(
        //         padding: const EdgeInsets.only(top: 2),
        //         child: Text(
        //           widget.info.getTripNoStr(),
        //           style: TextStyle(
        //             fontFamily: 'Montserrat',
        //             fontWeight: FontWeight.w500,
        //             fontSize: 15,
        //             color: widget.info.getStatusColor(),
        //           ),
        //         ),
        //       )
        //     : Text(""),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: screenW * 0.79,
          child: Column(
            children: [
              _buildCompanyRow(),
              const SizedBox(height: 2),
              TripBusLine(
                  info: widget.info.busLine,
                  driver_name: widget.trip['dirver_name'] ?? 'name',
                  detail: false),
              // _buildButtonsRow(),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.82;
    //final cardH = cardW * 0.675;

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     ElevatedButton(
    //       onPressed: () {},
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.white,
    //         foregroundColor: Colors.grey,
    //         elevation: 4,
    //         side: const BorderSide(width: 0.1, color: Colors.grey),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(18), // <-- Radius
    //         ),
    //       ),
    //       child: SizedBox(width: cardW, height: cardH),
    //     ),
    //     _buildCardContents(),
    //   ],
    // );
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return TripDetail(
                trip: widget.trip,
                avatar_url: avatar,
              );
            },
          ));
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: cardW * 1.1,
              //height: cardH,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildCardContents(),
            ),
            // widget.info.status == TripStatus.pending ? Container(
            //   width: 30,
            //   height: 30,
            //   // color: Colors.white,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black45)
            //   ),
            //   child: Image.asset("assets/pending_icon.png", fit: BoxFit.contain,)
            // ) : Container(width: 30, height: 30,),
            if (widget.info.status == TripStatus.pending ||
                widget.info.status == TripStatus.rejected ||
                widget.info.status == TripStatus.fake)
              Image(
                image: AssetImage("assets/pending_icon.png"),
                width: 50,
                height: 50,
              )
            else
              Container(
                width: 50,
                height: 50,
              )
            // widget.info.status == TripStatus.pending ? Image(
            //   image: AssetImage("assets/pending_icon.png"),
            //   width: 50,
            //   height: 50,
            // ) : Container(width: 50, height: 50,),
          ],
        ));
  }
}
