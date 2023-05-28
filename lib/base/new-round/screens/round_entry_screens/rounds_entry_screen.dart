import 'package:flutter/material.dart';

class RoundsEntryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  //final Widget widget;

  const RoundsEntryTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    // required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconLabel(icon: icon, label: label),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          )
        ],
      ),
    );
  }
}

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconLabel({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 14.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}