import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:driver_app/commons.dart';
import 'package:easy_localization/easy_localization.dart';

// trip status enum.
enum TripStatus {
  first,
  pending,
  accepted,
  rejected,
  started,
  canceled,
  finished,
  fake,
}

// trip status strings.
const List<String> kTripStatusStrings = [
  'first',
  'pending',
  'accepted',
  'rejected',
  'started',
  'canceled',
  'finished',
  'fake',
];

// trip status colors.
const List<Color> kTripStatusColors = [
  Color(0x00000000),
  Color(0xFFFBB03B),
  Color(0xFFA67C52),
  Color(0xFFED1C24),
  Color(0xFF29ABE2),
  Color(0xFFFF00FF),
  Color(0xFF39B54A),
  Color(0xFF838181),
];

///-----------------------------------------------------------------------------
/// CompanyInfo
///-----------------------------------------------------------------------------

class CompanyInfo {
  String companyName;
  String tripName;

  CompanyInfo({
    required this.companyName,
    required this.tripName,
  });

  String getCompanyImgPath() {
    final lowerStr = companyName.toLowerCase();
    return 'assets/images/company_$lowerStr.png';
  }
}

///-----------------------------------------------------------------------------
/// BusLineInfo
///-----------------------------------------------------------------------------

class BusLineInfo {
  DateTime fromTime;
  DateTime toTime;
  String courseName;
  String courseEndName;
  String cityEndName;
  String cityName;

  BusLineInfo({
    required this.fromTime,
    required this.toTime,
    required this.courseName,
    required this.courseEndName,
    required this.cityName,
    required this.cityEndName,
  });
  String getFromDateStr() {
    late DateFormat? formatter;
    if (Commons.dateType == '1') {
      formatter = DateFormat('dd/MM/yyyy');
    } else if (Commons.dateType == '0') {
      formatter = DateFormat('MM/dd/yyyy');
    }
    return formatter!.format(fromTime);
  }

  String getFromTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(fromTime);
  }

  String getFromTimeStr1() {
    final DateFormat formatter = DateFormat('hh:mm');
    return formatter.format(fromTime);
  }

  String getToDateStr() {
    // final DateFormat formatter = DateFormat('MMM d y (E)');
    late DateFormat? formatter;
    if (Commons.dateType == '1') {
      formatter = DateFormat('dd/MM/yyyy');
    } else if (Commons.dateType == '0') {
      formatter = DateFormat('MM/dd/yyyy');
    }
    return formatter!.format(toTime);
  }

  String getToTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(toTime);
  }

  String getToTimeStr1() {
    final DateFormat formatter = DateFormat('hh:mm ');
    return formatter.format(toTime);
  }

  String getDurTimeStr() {
    final Duration duration = toTime.difference(fromTime);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes Min';
  }
}

///-----------------------------------------------------------------------------
/// TripInfo
///-----------------------------------------------------------------------------

class TripInfo {
  TripStatus status;
  int tripNo;
  CompanyInfo company;
  String busNo;
  int passengers;
  BusLineInfo busLine;

  TripInfo({
    this.status = TripStatus.pending,
    required this.tripNo,
    required this.company,
    required this.busNo,
    required this.passengers,
    required this.busLine,
  });

  String getStatusImgPath() {
    final indexStr = status.index;
    return 'assets/images/trip_status$indexStr.png';
  }

  String getStatusStr() {
    return kTripStatusStrings[status.index];
  }

  Color getStatusColor() {
    return kTripStatusColors[status.index];
  }

  String getTripNoStr() {
    return 'Trip # $tripNo';
  }
}
