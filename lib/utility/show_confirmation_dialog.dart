import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/constants/constants.dart';

Future<bool> showConfirmationdialog(
  BuildContext context, {
  required String title,
  required String actionName,
}) async =>
    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (dialogContext, setState) {
          return AlertDialog(
            backgroundColor: Constants.boxBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: const BorderSide(color: Colors.white),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(
              actionName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              OutlinedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              OutlinedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            ],
          );
        });
      },
    ).then((value) => value ?? false);
