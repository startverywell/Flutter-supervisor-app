import 'dart:async';

import 'package:driver_app/notification.dart';
import 'package:driver_app/profile.dart';
import 'package:driver_app/widgets/navbar_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widgets/button_field.dart';
import 'widgets/input_field.dart';

class SubMaintwo extends StatefulWidget {
  const SubMaintwo({Key? key}) : super(key: key);

  @override
  State<SubMaintwo> createState() => _SubMaintwoState();
}

class _SubMaintwoState extends State<SubMaintwo> {
  int _selectedIndex = 0;
  static List<bool> isSelected = [false, false, false, false];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static Widget getWidget(BuildContext context, int index) {
    List<Widget> _widgetOptions = <Widget>[
      Container(
          child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //     image: AssetImage("assets/bg.png"), fit: BoxFit.cover)
                color: Colors.blue),
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 22),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height / 18,
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search Driver, Trip, Bus No.",
                        hintStyle: TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 30),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          // color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
      Container(
        child: Center(
          child: Text("TODO: HERE WE CODE"),
        ),
      ),
      Container(
        child: NotificationPage(),
      ),
      Container(
        child: Profile(),
      )
    ];
    return _widgetOptions[index];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = false;
      }
      isSelected[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: getWidget(context, _selectedIndex),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.orange),
          child: BottomNavigationBar(
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    child: NavBarButton(
                        imageName: "assets/navbar_track2.png",
                        displayName: "1",
                        isSelected: isSelected[0]),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Container(
                    child: NavBarButton(
                        imageName: "assets/navbar_trip.png",
                        displayName: "2",
                        isSelected: isSelected[1]),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Container(
                    child: NavBarButton(
                        imageName: "assets/navbar_notification.png",
                        displayName: "3",
                        isSelected: isSelected[2]),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Container(
                    child: NavBarButton(
                        imageName: "assets/navbar_user.png",
                        displayName: "4",
                        isSelected: isSelected[3]),
                  ),
                  label: ''),
            ],
          ),
        ));
  }
}
