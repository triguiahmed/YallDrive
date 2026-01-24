import 'package:flutter/material.dart';

void showSnackerbar(BuildContext context, String content,
    {String title = "Error"}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
              color: title == "Error" ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
