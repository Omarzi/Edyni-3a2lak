import 'package:flutter/material.dart';

import '../../../Theme/color.dart';
import '../../../widget/myText.dart';

class QuestionBodyComponent extends StatelessWidget {
  final String categoryName;
  final String questionBody;
  const QuestionBodyComponent({Key? key,required this.categoryName,required this.questionBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(
          title:categoryName,
          fontWeight: FontWeight.w500,
          size: 16,
          colors: textColorGrey,
        ),
        const SizedBox(height: 15),
        MyText(
          title:questionBody,
          fontWeight: FontWeight.w500,
          size: 18,
          maxline: 4,
          textalign: TextAlign.center,
          colors: textColorGrey,
        ),
      ],
    );
  }
}
