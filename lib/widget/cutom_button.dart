import 'package:flutter/material.dart';

import '../Theme/color.dart';
import 'myText.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title ;
  const CustomButton({Key? key,required this.onPressed,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            minimumSize:
            MaterialStateProperty.all(const Size(200, 50)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0))),
            backgroundColor: MaterialStateProperty.all(appColor)),
        child: MyText(
          title: title ,
          size: 18,
          fontWeight: FontWeight.w500,
          colors: white,
        ));
  }
}
