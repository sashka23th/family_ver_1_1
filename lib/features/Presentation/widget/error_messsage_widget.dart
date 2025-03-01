import 'package:flutter/material.dart';

Widget errorMessageWidget(String message) {
  return Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
