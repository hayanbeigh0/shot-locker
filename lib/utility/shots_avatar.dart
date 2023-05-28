import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShotAvatar extends StatelessWidget {
  final String imageUrl;
  final String label;
  final Color textColor;

  final String logoText;

  final Color labelBg;
  final double size;

  const ShotAvatar({
    Key? key,
    this.size = 22.0,
    required this.imageUrl,
    required this.label,
    this.textColor = Colors.black,
    required this.logoText,
    required this.labelBg,
  }) : super(key: key);

  // const ShotAvatar({
  //   Key? key,
  //   required this.imageUrl,
  //   required this.label,
  //   this.textColor = Colors.black,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: size,
          backgroundColor: labelBg,
          child: Text(
            logoText,
            style: GoogleFonts.patrickHand(
              color: Colors.black,
              fontSize: 30.0,
              fontWeight: FontWeight.w900,
              //fontStyle: FontStyle.italic,
            ),
          ),
        ),
        // CircleAvatar(
        //   radius: 23.0,
        //   backgroundImage: AssetImage(
        //     imageUrl,
        //   ),
        // ),
        const SizedBox(height: 5.0),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const SizedBox(height: 5.0),
        // Text(
        //   score,
        //   style: const TextStyle(
        //     color: Colors.blueGrey,
        //     fontSize: 16.0,
        //     fontWeight: FontWeight.w800,
        //   ),
        // ),
      ],
    );
  }
}
