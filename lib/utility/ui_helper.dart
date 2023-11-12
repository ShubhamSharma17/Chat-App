import 'package:chat_app/utility/utility.dart';
import 'package:flutter/material.dart';

class UIHelper {
  // loading dialog method..
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          verticalSpaceMedium,
          Text(title),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      },
    );
  }

  // alert dialog method..
  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
