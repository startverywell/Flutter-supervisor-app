import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Commons {
  static bool isTrip = false;
  static bool isLogin = false;
  static String login_id = "";
  static String dateType = "";

  static String name = "";
  static String token = "";
  static String fcm_token = "";
  static String baseUrl = "http://167.86.102.230/alnabali/public/android/";
  static String cookie =
      "XSRF-TOKEN=eyJpdiI6Inc1YW0wQ29WVlJaUUF3V2RkUXRVaVE9PSIsInZhbHVlIjoibDkrMmRmSFFNQkxZbENybFFscXo1d3hHUXAySFVBWE1XbEthRFoybStRT0ZETk9BcXlLRXkrQmZYSnRzODZ6aHRjamtNZ1RyK2VKbmFlS3BNTGtSS1g1NnhjNjJ0RHVReUVjTFpBMzhlaytCc3hVWDBJZWxNOTVUYURrakRud3YiLCJtYWMiOiIzYzNmOTU1NDA0ODkxZTU3NWQzMDQyMmMzZThmMDU2OWQ3ODkzYTY2ZGI1ZWViNmU0M2VmMmMwZDBhYjg1YzlmIn0%3D; laravel_session=eyJpdiI6IndwREYyUnNob3B2aUtiam5JdEE0ckE9PSIsInZhbHVlIjoiL1FUejBJbUEwcG9lWnl5NmtXVlQzQ1VRVzZZWEhZZDIwbnpnNFBuSTBuclpESjBKTkhPaFdhdlFTQWFuNUh4MWErOGdSTVdkVkZyYnEvOEJ1RVhTWUEvRlA0TlRPZC9jL0NVZlRRWkRCaUZXUHlEYWNqVTIzV2hwZnBPZzhVVjEiLCJtYWMiOiIzZDczOWM1Y2ViZDE0OTE2N2M5ODYyNDdkMmRlYzMyOGUwNjU2MmY0NTcxZGU2NGI4MTM1ZTEwZWE2MGY5ZWVmIn0%3D";

  static String APIKEY = "AIzaSyBgmDKTs8cHeDgOG-Srw76Yac8vNFUcXPc";

  static String APIKEY2 = "AIzaSyDex_ZN1s9cNPkU4VCjtE9OmTHBQeZzOWM";

  static var marea = {};
  static var mcity = {};

  static Future<String?> getCity(String id) async {
    String? cityName = null;

    String url = "${Commons.baseUrl}city/${id}";

    var response = await http.get(
      Uri.parse(url!),
    );

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("msg6" + responseJson.toString());
    if (response.statusCode == 200) {
      cityName = responseJson['city'];
    }

    return cityName;
    // return http.get(Uri.parse(url!),);
  }

  static Future<String?> getArea(String id) async {
    String? cityName = null;

    String url = "${Commons.baseUrl}area/${id}";

    var response = await http.get(
      Uri.parse(url!),
    );

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("msg6" + responseJson.toString());
    if (response.statusCode == 200) {
      cityName = responseJson['area'];
    }

    return cityName;
  }

  static int getYear(String date) {
    List<String> datelist = date.split('-');
    return int.parse(datelist[0]);
  }

  static int getMonth(String date) {
    List<String> datelist = date.split('-');
    return int.parse(datelist[1]);
  }

  static int getDay(String date) {
    List<String> datelist = date.split('-');
    return int.parse(datelist[2]);
  }

  static int getHour(String time) {
    List<String> datelist1 = time.split(' ');
    List<String> datelist2 = datelist1[0].split(':');
    if (datelist1.length > 1 && datelist1[1] == "PM") {
      return int.parse(datelist2[0]) + 12;
    }
    return int.parse(datelist2[0]);
  }

  static int getMinute(String time) {
    List<String> datelist1 = time.split(' ');
    List<String> datelist2 = datelist1[0].split(':');
    return int.parse(datelist2[1]);
  }

  static void showErrorMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: 16.0);
  }

  static void showSuccessMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.green,
        fontSize: 16.0);
  }

  static DateTime convertTimeString(String timeString) {
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(2022, 1, 1, hour, minute);
  }
}
