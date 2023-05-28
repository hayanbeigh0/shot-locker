import 'package:flutter/material.dart';

class ErrorHandler {
  // static String loginFailedMessage(String incomingError) {
  //   var errorMessage = 'Something went wrong.';
  //   if (incomingError
  //       .toString()
  //       .contains('Unable to log in with provided credentials.')) {
  //     errorMessage = 'Invalid credentials.';
  //   }
  //   return errorMessage;
  // }

  static Widget errorHandler({
    String actionMessage = 'Tap to try again',
    required String errorMessage,
    required Size deviceSize,
    required Function action,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: deviceSize.height * 0.06),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16),
          ),
          SizedBox(height: deviceSize.height * 0.04),
          Text(actionMessage),
          IconButton(
            onPressed: () => action(),
            icon: const Icon(Icons.refresh),
            iconSize: 28,
          ),
        ],
      );
}
