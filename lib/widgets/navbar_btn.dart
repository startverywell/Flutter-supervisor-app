import 'package:flutter/material.dart';

class NavBarButton extends StatefulWidget {
  final String imageName;
  final String displayName;
  final bool isSelected;
  const NavBarButton({Key? key, required this.imageName, required this.isSelected, required this.displayName}) : super(key: key);

  @override
  State<NavBarButton> createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<NavBarButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.isSelected ? Container(
          width: MediaQuery.of(context).size.width/5,
          height: MediaQuery.of(context).size.height/20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.imageName, width: 30, height: 30, color: Colors.red,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.displayName,
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              )
            ],
          ),
        ) :
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.imageName, width: 30, height: 30,),
          ],
        )
    );
  }
}

