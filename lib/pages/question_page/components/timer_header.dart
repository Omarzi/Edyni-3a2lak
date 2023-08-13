import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/providers/questions_provider.dart';

import '../../../Theme/color.dart';

class TimerHeader extends StatefulWidget {

  const TimerHeader({Key? key}) : super(key: key);

  @override
  State<TimerHeader> createState() => _TimerHeaderState();
}

class _TimerHeaderState extends State<TimerHeader> {
  @override
  Widget build(BuildContext context) {

    return Consumer<QuestionsProvider>(
      builder: (context, questionsProvider, child) {
        return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              child: Container(
                height: 70,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: primary, width: 4),
                    color: white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(100))),
                child: CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 4.0,
                  animation: false,
                  percent: questionsProvider.percent / 20,
                  center: Text(
                    questionsProvider.percent.toInt().toString(),
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  backgroundColor: Colors.grey,
                  circularStrokeCap:
                  CircularStrokeCap.round,
                  progressColor: Colors.redAccent,
                ),
              ),
            ),
            // Question Count
            Positioned(
              top: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 30, right: 30),
                child: Row(
                  children: [
                    Row(
                      children: [

                        LinearPercentIndicator(
                          width: MediaQuery.of(context)
                              .size
                              .width /
                              3,
                          animation: false,
                          lineHeight: 3.0,
                          percent: 0.5,
                          barRadius:
                          const Radius.circular(20),
                          progressColor:
                          Colors.greenAccent,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        LinearPercentIndicator(
                          width: MediaQuery.of(context)
                              .size
                              .width /
                              3,
                          animation: false,
                          lineHeight: 3.0,
                          percent: 0.5,
                          barRadius:
                          const Radius.circular(20),
                          progressColor: Colors.red,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
      } ,

    );
  }
}
