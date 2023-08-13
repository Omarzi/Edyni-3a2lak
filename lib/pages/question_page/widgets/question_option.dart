import 'package:flutter/material.dart';

import '../../../../Theme/color.dart';
import '../../../../widget/myText.dart';

class QuestionOption extends StatefulWidget {
  final String option;
  final bool isSelected ;
  const QuestionOption({Key? key,required this.option,required this.isSelected}) : super(key: key);

  @override
  State<QuestionOption> createState() => _QuestionOptionState();
}

class _QuestionOptionState extends State<QuestionOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context)
          .size
          .width,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(
          left: 25, right: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color:widget.isSelected? green:textColorGrey, width: 0.4),
          color: widget.isSelected? green:null,
          borderRadius:
          const BorderRadius.all(
              Radius.circular(25))),
      child: MyText(
        title:widget.option ,
        overflow: TextOverflow.ellipsis,
        maxline: 2,
        size: 18,
        colors: Colors.black,
        fontWeight:widget.isSelected? FontWeight.w500:null,
        textalign: TextAlign.left,
      ),
    );
  }
}
