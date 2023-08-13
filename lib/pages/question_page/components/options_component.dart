import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/model/question_model.dart';

import '../../../providers/questions_provider.dart';
import '../widgets/question_option.dart';

class QuestionComponent extends StatefulWidget {
    final List<Options> questionOptions;
    final int questionNumber;
   const QuestionComponent({Key? key,required this.questionOptions,required this.questionNumber}) : super(key: key);

  @override
  State<QuestionComponent> createState() => _QuestionComponentState();
}

class _QuestionComponentState extends State<QuestionComponent> {
  int selectedAnswer=-1;
  int questionNumber= -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context);
    if(questionNumber !=widget.questionNumber)
      {
        selectedAnswer=-1;
        questionNumber= widget.questionNumber;
        Future.delayed(const Duration(milliseconds: 500)).then((value) => setState((){}));
      }

    return Container(
      alignment: Alignment.topCenter,
      padding:
      const EdgeInsets.only(left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.questionOptions.length,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedAnswer = index;
                  questionsProvider.selectedAnswer = widget.questionOptions[index].option!;
                });
              },
              child: selectedAnswer == index
                  ? QuestionOption(option:widget.questionOptions[index].option!, isSelected: true,)
                  : QuestionOption(option: widget.questionOptions[index].option!, isSelected: false),
            );
          }),
    );
  }
}
