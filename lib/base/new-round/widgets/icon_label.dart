import 'package:flutter/material.dart';

class LabelIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const LabelIcon({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Icon(icon),
        const SizedBox(width: 5.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        const Spacer()
      ],
    );
  }
}
