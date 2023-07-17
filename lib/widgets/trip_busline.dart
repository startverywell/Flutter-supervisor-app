import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/trip_info.dart';

class TripBusLine extends StatefulWidget {
  final BusLineInfo info;

  final String driver_name;
  final bool detail;

  const TripBusLine({
    Key? key,
    required this.info,
    required this.driver_name,
    required this.detail,
  }) : super(key: key);

  @override
  State<TripBusLine> createState() => _TripBusLineState();
}

class _TripBusLineState extends State<TripBusLine> {
  Widget _buildTimeLineRow() {
    const dateTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 8,
      color: kColorSecondaryGrey,
    );
    const timeTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 9,
      color: Color.fromRGBO(244, 130, 34, 1),
    );
    print(widget.info.getToTimeStr().substring(6) == null ? widget.info.getToTimeStr().substring(6).tr() + " "+ widget.info.getToTimeStr1(): "AM".tr()+ widget.info.getToTimeStr1());
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getFromDateStr(),
              style: dateTextStyle,
            ),
            Text(
              // widget.info.getFromTimeStr().substring(6) == null ? widget.info.getFromTimeStr().substring(6).tr() + " "+ widget.info.getFromTimeStr1(): "AM".tr()+ widget.info.getFromTimeStr1(),
              widget.info.getFromTimeStr(),
              style: timeTextStyle,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getToDateStr(),
              style: dateTextStyle,
            ),
            Text(
              widget.info.getToTimeStr(),
              // widget.info.getToTimeStr().substring(6) == null ? widget.info.getToTimeStr().substring(6).tr() + " "+ widget.info.getToTimeStr1(): "AM".tr()+ widget.info.getToTimeStr1(),
              style: timeTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusRow() {
    final screenW = MediaQuery.of(context).size.width;
    final busFromW = screenW * 0.13;
    final busToW = screenW * 0.04;
    final timerW = screenW * 0.022;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.blue),
        ),
      ),
      child: Row(
        children: [
          Image(
            width: busFromW,
            image: const AssetImage('assets/images/bus_from.png'),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  width: timerW,
                  image: AssetImage('assets/images/bus_time.png'),
                  color: Color.fromRGBO(244, 130, 34, 1),
                ),
                const SizedBox(width: 2),
                Text(
                  widget.info.getDurTimeStr(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    color: Color.fromRGBO(244, 130, 34, 1),
                  ),
                ),
              ],
            ),
          ),
          Image(
            width: busToW,
            image: const AssetImage('assets/images/bus_to.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow() {
    const courseTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 8,
      color: Color(0xFF4C4C4C),
    );
    const cityTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 9,
      color: Color(0xFFB3B3B3),
    );
    print(widget.info);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.courseName,
              style: courseTextStyle,
            ),
            Text(
              widget.info.cityName,
              style: cityTextStyle,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.courseEndName,
              style: courseTextStyle,
            ),
            Text(
              widget.info.cityEndName,
              style: cityTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.6),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(10), // Set the padding to 8 pixels on all sides
      child: Column(
        children: [
          _buildTimeLineRow(),
          const SizedBox(height: 5),
          _buildBusRow(),
          const SizedBox(height: 6),
          _buildCourseRow(),
          !widget.detail
              ? Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          "DRIVER".tr(),
                          style: TextStyle(
                              color: Color.fromRGBO(244, 130, 34, 1),
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.driver_name,
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    )
                  ],
                )
              : Row()
        ],
      ),
    );
  }
}
