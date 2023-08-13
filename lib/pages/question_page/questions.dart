import 'dart:developer';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:quizapp/Pages/home.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/common/constants/variables-methods.dart';

import 'package:quizapp/pages/question_page/components/app_bar.dart';
import 'package:quizapp/pages/question_page/components/options_component.dart';
import 'package:quizapp/pages/question_page/components/question_actions_component.dart';
import 'package:quizapp/pages/question_page/components/timer_header.dart';
import 'package:quizapp/providers/questions_provider.dart';
import 'package:quizapp/providers/user_provider.dart';

import '../../widget/challenge_app_bar.dart';
import 'components/question_component.dart';

class Questions extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final int? currentCategoryLevel;
  final String levelId;
  final String levelNumber;
  final String levelGift;
  final bool normalLevelQuestions;
  final bool? isChallenge;

  const Questions(
      {Key? key,
      required this.categoryId,
      required this.levelId,
      required this.categoryName,
      required this.normalLevelQuestions,
      required this.levelGift,
      this.isChallenge,
      this.currentCategoryLevel,
      required this.levelNumber})
      : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> with WidgetsBindingObserver {
  @override
  void initState() {
    QuestionsProvider questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isChallenge == null) {
        await questionsProvider.getLevelQuestions(
            levelId: widget.levelId,
            normalsLevelQuestions: widget.normalLevelQuestions);
      } else {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        await questionsProvider.getChallengeQuestions(
            userPoints: userProvider.currentUser!.gold!,
            context: context,
            userProvider: userProvider);
      }

      if (widget.isChallenge == null) {
        questionsProvider.initProvider(
            categoryName: widget.categoryName,
            categoryLevel: widget.currentCategoryLevel,
            categoryId: widget.categoryId,
            levelGift: widget.levelGift,
            isNotCompetation: widget.normalLevelQuestions);
      } else {
        questionsProvider.initProvider(isChallenge: true);
      }
    });
  }

  bool paused= false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('app state ${state.name}');
    //showErrorToast('app state ${state.name}');
    if (state == AppLifecycleState.paused) {
      if (mounted) {
        log(' from resumed state ');
        paused = true;
        Provider.of<QuestionsProvider>(context, listen: false).timer!.cancel();
        Get.offAll(const Home());
      }
    }

    if (state == AppLifecycleState.inactive) {
      if (mounted) {
        //showErrorToast('timer canceled');
        QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
        Future.delayed(const Duration(seconds: 1)).then((value) => questionsProvider.timer!.cancel());

      }
    }

    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        if(!paused)
          {
            QuestionsProvider questionsProvider =
            Provider.of<QuestionsProvider>(context, listen: false);
            questionsProvider.resetTimer('from app resumed');
          }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, questionsProvider, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: WillPopScope(
            onWillPop: () async {
              questionsProvider.timer?.cancel();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: getAppBar(widget.isChallenge, questionsProvider)),
              body: SafeArea(
                child: questionsProvider.currentQuestions.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/login_bg_white.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TimerHeader(),
                              const SizedBox(height: 15),
                              QuestionBodyComponent(
                                categoryName: widget.isChallenge == null
                                    ? widget.categoryName
                                    : questionsProvider.challengeGift,
                                questionBody: questionsProvider
                                    .currentQuestions[questionsProvider.quecnt]
                                    .body
                                    .toString(),
                              ),
                              const SizedBox(height: 25),
                              QuestionComponent(
                                questionOptions: questionsProvider
                                    .currentQuestions[questionsProvider.quecnt]
                                    .options!,
                                questionNumber: questionsProvider.quecnt,
                              ),
                              QuestionActionsComponent(
                                categoryId: widget.categoryId,
                                categoryName: widget.categoryName,
                              )
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: primary,
                        ),
                        // Text(
                        //   widget.isChallenge==null?'عفوا لايوجد اسئلة':'عفوا لايوجد تحديات الان',
                        //   style: Get.theme.textTheme.subtitle2!
                        //       .copyWith(color: Colors.white),
                        // ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getAppBar(bool? isChallenge, questionsProvider) {
    switch (isChallenge) {
      case true:
        return const ChallengeAppBar();
      default:
        return LevelAppBar(
            levelNumber: widget.levelNumber,
            questionNumber: questionsProvider.quecnt,
            questionsCount: questionsProvider.currentQuestions.length,
            hasData: questionsProvider.currentQuestions.isNotEmpty);
    }
  }
}
