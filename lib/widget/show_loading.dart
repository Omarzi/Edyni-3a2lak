import 'package:flutter/material.dart';
import '../main.dart';

void showLoading({Color? loadingColor})
{
  showDialog<String>(
    barrierDismissible: false,
    context: navigatorKey.currentContext!,
    barrierColor: Colors.black38,
    builder: (BuildContext context) =>
      WillPopScope (
        onWillPop: () async {
          return false;
        },
        child: const AlertDialog(

          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Center(
            child: CircularProgressIndicator(
            ),
          ),
        ),
      )
  );
}
void hideLoading() => Navigator.pop(navigatorKey.currentContext!);