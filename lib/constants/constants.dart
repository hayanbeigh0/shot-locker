import 'package:flutter/material.dart';

class Constants {
  // static const Color primaryColor = Color(0xffFBFBFB);
  //static const Color primaryColor = Color(0xffffdf00);
  // static const Color primaryColor = Color(0xffa77f47);
  static const Color primaryColor = Color(0xffbf8e49);
  static const String otpGifImage = 'assets/otp.gif';

  static Color deepBlue = const Color(0xff466aff);
  static Color lightBlue = const Color(0xff5879ff);

  static Color sendBackgroundColor = const Color(0xffcfe3ff);
  static Color sendIconColor = const Color(0xff3f63ff);

  static Color activitiesBackgroundColor = const Color(0xfffbcfcf);
  static Color activitiesIconColor = const Color(0xfff54142);

  static Color statsBackgroundColor = const Color(0xffd3effe);
  static Color statsIconColor = const Color(0xff3fbbfe);

  static Color paymentBackgroundColor = const Color(0xffefcffe);
  static Color calendarBackgroundColor = const Color.fromRGBO(34, 219, 200, 1);
  static Color calendarTextColor = Colors.white;
  static Color paymentIconColor = const Color(0xffef3fff);

  static Color boxBgColor = Colors.black;


  static const gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        Color(0xff0a1014),
        // Color(0xff1a252c),
        Color(0xff1a252c),
        Color(0xff0a1014),
        Colors.black54
      ],
    ),
  );
}

const String errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';
const String loremIpsum =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 2100s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries';

const String newsLoremIpsum =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';
