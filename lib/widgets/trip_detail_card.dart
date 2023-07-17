import 'package:driver_app/commons.dart';
import 'package:driver_app/sub_main.dart';
import 'package:driver_app/trip_detail.dart';
import 'package:driver_app/trip_detail_pending.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/trip_info.dart';
import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/trip_busline.dart';
import 'package:driver_app/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailCard extends StatefulWidget {
  final TripInfo info;
  final dynamic trip;
  final VoidCallback onPressed;
  final avatar_url;

  const TripDetailCard({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.trip,
    this.avatar_url,
  }) : super(key: key);

  @override
  State<TripDetailCard> createState() => _TripDetailCardState();
}

class _TripDetailCardState extends State<TripDetailCard> {
  Function get onPressed => onPressed;
  Widget _buildCompanyRow() {
    final screenW = MediaQuery.of(context).size.width;
    final avatarRadius = screenW * 0.0924 * 0.5;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.transparent,
            // backgroundImage: AssetImage(widget.info.company.getCompanyImgPath()),
            backgroundImage: NetworkImage(widget.avatar_url),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info.company.companyName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.company.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: widget.info.getStatusColor(),
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
              'bus_no'.tr(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color.fromRGBO(244, 130, 34, 1),
              ),
            ),
            Text(
              widget.info.busNo,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color.fromRGBO(244, 130, 34, 1),
              ),
            ),
            Text(
              'passenger'.tr(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color.fromRGBO(244, 130, 34, 1),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenW * 0.035,
                  child: Image.asset(
                    'assets/images/passengers.png',
                    color: Color.fromRGBO(244, 130, 34, 1),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.info.passengers.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color.fromRGBO(244, 130, 34, 1),
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
        // For Detail
        // Padding(
        //   padding: const EdgeInsets.only(top: 2),
        //   child: Text(
        //     widget.info.getTripNoStr(),
        //     style: TextStyle(
        //       fontFamily: 'Montserrat',
        //       fontWeight: FontWeight.w500,
        //       fontSize: 15,
        //       color: widget.info.getStatusColor(),
        //     ),
        //   ),
        // ),
        SizedBox(
          width: screenW * 0.76,
          child: Column(
            children: [
              _buildCompanyRow(),
              const SizedBox(height: 2),
              TripBusLine(
                  info: widget.info.busLine,
                  driver_name: widget.trip['dirver_name'],
                  detail: true),
              // _buildButtonsRow(),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Details".tr(),
                    style: TextStyle(
                        color: Color.fromRGBO(244, 130, 34, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "${widget.trip['origin_area'] ?? 'here'} - ${widget.trip['destination_area'] ?? 'here'} ",
                    style: TextStyle(color: Colors.black26, fontSize: 10),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "DRIVER".tr(),
                    style: TextStyle(
                        color: Color.fromRGBO(244, 130, 34, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 30),
                  child: Text(
                    widget.trip['dirver_name'] ?? "Driver Name",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
          if (widget.info.getStatusStr() == "Started") {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SubMain(trip: widget.trip);
              },
            ));
          }
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
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
            if (widget.info.status == TripStatus.pending ||
                widget.info.status == TripStatus.rejected ||
                widget.info.status == TripStatus.fake)
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TripDetailPending(
                        trip: widget.trip,
                      );
                    },
                  ));
                },
                child: Image(
                  image: AssetImage("assets/pending_icon.png"),
                  width: 50,
                  height: 50,
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
              ),
          ],
        ));
  }
}
