import 'package:driver_app/widgets/constants.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final String title;

  const GradientButton({
    Key? key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(50);
    const gradientColor = Color(0xFFD4D4D4);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          stops: [0.1, 0.5, 1.0],
          colors: [gradientColor, Colors.white, gradientColor],
        ),
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: kColorPrimaryBlue,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 9,
            color: kColorPrimaryBlue,
          ),
        ),
      ),
    );
  }
}
