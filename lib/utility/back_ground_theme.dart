import 'package:flutter/material.dart';

class ShotLockerBackgroundTheme extends StatelessWidget {
  final Widget child;
  const ShotLockerBackgroundTheme({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Color(0xff0a1014),
            Color(0xff1a252c),
            Color(0xff0a1014),
            Colors.black54
          ],
        ),
      ),
      child: Center(child: child),
    );
  }
}
