import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Theme/color.dart';
import '../../../providers/questions_provider.dart';
import '../../../widget/myText.dart';

class LevelAppBar extends StatefulWidget {
  final String levelNumber;
  final int questionNumber;
  final int questionsCount;
  final bool hasData;
  const LevelAppBar({Key? key,required this.levelNumber,required this.questionNumber,required this.questionsCount,required this.hasData }) : super(key: key);

  @override
  State<LevelAppBar> createState() => _LevelAppBarState();
}

class _LevelAppBarState extends State<LevelAppBar> {

  @override
  Widget build(BuildContext context) {

    QuestionsProvider questionsProvider =
    Provider.of<QuestionsProvider>(context, listen: false);
    return AppBar(
      centerTitle: true,
      title: Center(
        child: MyText(
          title: "المستوي ${widget.levelNumber}",
          size: 18,
          fontWeight: FontWeight.w400,
          colors: white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: Colors.white, size: 30),
        onPressed: () {
          questionsProvider.timer?.cancel();
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        if (widget.hasData)
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: MyText(
                  title: (widget.questionNumber + 1).toString() +
                      '/' +
                      widget.questionsCount
                          .toString(),
                  size: 18,
                  fontWeight: FontWeight.w400,
                  colors: white),
            ),
          ),
      ],
    );
  }
}
