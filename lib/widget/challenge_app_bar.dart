import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/providers/questions_provider.dart';

import '../Pages/level.dart';
import '../Theme/color.dart';
import 'myText.dart';

class ChallengeAppBar extends StatelessWidget {
  const ChallengeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context , listen: false);
    return AppBar(
      centerTitle: true,
      title: Center(
        child: MyText(
          title: "التحديات",
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
    );
  }
}
