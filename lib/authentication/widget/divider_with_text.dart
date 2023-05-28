import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Row(children: <Widget>[
      const Expanded(child: Divider(color: Colors.white)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.04),
        child: Text(text),
      ),
      const Expanded(child: Divider(color: Colors.white)),
    ]);
  }
}
