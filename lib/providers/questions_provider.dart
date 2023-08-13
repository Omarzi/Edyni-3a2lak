import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as Get;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/Pages/home.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/model/question_model.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/utils/constant.dart';

import '../Pages/category.dart';
import '../Theme/color.dart';
import '../widget/wrong_question_answer.dart';

class QuestionsProvider extends ChangeNotifier {
  double percent = 0.0;
  Timer? timer = Timer(const Duration(seconds: 0), () {});
  int quecnt = 0;
  int answercnt = 1;
  String selectedAnswer = '';
  int points = 0;
  int wrongAnwerCount=0;
  QuestionModel? randomQuestionAfterAds;
  List<QuestionModel> currentQuestions = [];

  void resetTimer(String fromWhere) {
    //showErrorToast('timer reset from $fromWhere');
    if (timer!.isActive) {
      timer!.cancel();
    }
    percent = 0.0;
    startTimer();
  }

  void startTimer() {
    log('timer is active ${timer!.isActive.toString()}');
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      percent += 1;
      log('Started New Timer $percent');
      if (percent >= 20) {
        timer?.cancel();
        percent = 0;
        handleAnswerAfterTime();
      }
      notifyListeners();
    });

    log('timer is active ${timer!.isActive.toString()}');
  }

  void handleAnswerAfterTime() {
    if (!isChallenge) {
      if (isUserAnsweredTheQuestion()) {
        if (checkIsCorrectAnswer()) {
          showSuccessToast('اجابة صحيحة');
          wrongAnwerCount=0;
          nextQuestion();
        } else {
          Get.Get.dialog(const WrongQuestionAnswer(
            title: 'اجابة خاطئة',
          ));
        }
      } else {
        Get.Get.dialog(const WrongQuestionAnswer(
          title: 'الوقت انتهي',
        ));
      }
    } else {
      nextQuestion();
    }
  }

  bool isUserAnsweredTheQuestion() {
    return (selectedAnswer != '');
  }

  bool hasMoreQuestions() {
    return (quecnt < currentQuestions.length - 1);
  }

  void nextQuestion() {
    if (isUserAnsweredTheQuestion()) {
      if (hasMoreQuestions()) {
        quecnt++;
        selectedAnswer = '';
        notifyListeners();
        resetTimer('next quest');
      }
    } else {
      showErrorToast('برجاء الاجابة على السؤال اولا');
    }
  }

  void forceNextQuestion() {
    quecnt++;
    selectedAnswer = '';
    resetTimer('force next quest');
    notifyListeners();
  }

  String categoryName = '';
  String categoryId = '';
  bool isNotCompetation = false;
  bool isChallenge = false;
  String levelGift = '';
  String challengeGift = '';
  int currentCategoryLevel =0;

  void initProvider(
      {String? categoryName,
      String? categoryId,
      bool? isChallenge,
      bool? isNotCompetation,
        int?  categoryLevel,
      String? levelGift}) {
    quecnt = 0;
    answercnt = 1;
    points = 0;
    currentCategoryLevel = categoryLevel??0;
    debugMessage('from init');
    debugMessage('$categoryName + $categoryId + $isChallenge + $isNotCompetation + $levelGift ');
    if (currentQuestions.isNotEmpty) resetTimer('ffrom init provider');
    this.categoryName = categoryName ?? '';
    this.categoryId = categoryId ?? '';
    this.isChallenge = isChallenge ?? false;
    this.isNotCompetation = isNotCompetation ?? false;
    this.levelGift = levelGift ?? '';
  }



  Future getLevelQuestions(
      {required String levelId, required bool normalsLevelQuestions}) async {
    try {


          Map<String, dynamic> res = await DioHelper().getData(
            (normalsLevelQuestions
                ? levelQuestions
                : competitionsLevelQuestions) +
                '/$levelId',
          );
          if (res['success'] == true) {
            List data = res['questions'];

            currentQuestions = [];

            data.forEach((element) {
              currentQuestions.add(QuestionModel.fromJson(element));
            });
            debugMessage(currentQuestions.length.toString() + ' length');

            notifyListeners();
            return true;
          } else {
            showErrorToast(res['message']);
          }
          return false;

    } catch (error) {
      debugMessage('from catch '+error.toString());
      return false;
    }
  }

  DateTime? _startChallengeTime;
  DateTime? _endChallengeTime;

  setStartChallengeTime(DateTime start) {
    _startChallengeTime = start;
  }

  setEndChallengeTime(DateTime end) {
    _endChallengeTime = end;
  }

  int getSolutionChallengeTime() {
    return _endChallengeTime!.difference(_startChallengeTime!).inSeconds;
  }


  bool isThereChallenge = false;

  Future getChallengeQuestions({required int userPoints,required context , required UserProvider userProvider}) async {
    currentQuestions = [];
    try {
      Map<String, dynamic> res = await DioHelper().getData(
       challengeQuestions,
      );
      if (res['success'] == true) {

        if(userPoints >= res['result']['min_points'])
          {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'تنبيه !!',
              text:
              'سوف يتم خصم ${res['result']['min_points']} نقط لدخول هذا التحدي ',
              confirmBtnColor: primary,
              confirmBtnText: 'موافق',
              cancelBtnText: 'الرجوع',
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Get.Get.back();
                userProvider
                    .decrementUserPoints(
                    points: res['result']['min_points'])
                    .then((value) {
                  showSuccessToast('تم خصم ${res['result']['min_points']} نقطه بنجاح ');
                  List data = res['result']['questions'];
                  if (data.isNotEmpty) {
                    challengeGift = 'الجائزة ${res['result']['gift']}';
                    setStartChallengeTime(DateTime.now());
                    currentQuestions = [];
                    isThereChallenge = true;
                    data.forEach((element) {
                      currentQuestions.add(QuestionModel.fromJson(element));
                    });
                    debugMessage(currentQuestions.length.toString() + ' length');
                    notifyListeners();
                    return true;
                  } else {
                    isThereChallenge = false;
                    showErrorToast('عفوا لا يوجد تحديات الان');
                    notifyListeners();
                    return false;
                  }
                });
              },
              onCancelBtnTap: () {
                Get.Get.to(const Home());
              },
              showCancelBtn: true,
            );

          }else
            {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'عفوا',
                text: 'عدد العملات لديك لا تكفي لدخول التحدي',
                confirmBtnText: 'جمع العملات',
                confirmBtnTextStyle: Get.Get.textTheme.subtitle1!
                    .copyWith(color: Colors.white),
                cancelBtnText: 'الرجوع',
                confirmBtnColor: primary,
                barrierDismissible: false,
                onConfirmBtnTap: () {
                  Get.Get.to(const Home());
                  Get.Get.to(const Category(
                    normalCat: true,
                  ));
                },
                onCancelBtnTap: () {
                  Get.Get.to(const Home());
                },
                showCancelBtn: true,
              );
              notifyListeners();
              return false;
            }

      } else {
        showErrorToast(res['message']);
      }
      notifyListeners();
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }

  Future sendChallengeWinner({required String userId}) async {
    try {
      setEndChallengeTime(DateTime.now());
      Map<String, dynamic> res = await DioHelper().postData(
          challengeWinner + userId,  data:  {"time": getSolutionChallengeTime(), "score": points});
      if (res['success'] == true) {
        bool added = res['result']['added'];
        if (added) {
          showSuccessToast('ستم مراجعة الفائزين و التواصل معك قريبا');
          return true;
        } else {
          showErrorToast('عفوا لقد خضت هذا التحدي من قبل');
          return false;
        }
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }

  Future addNewWinner({required String userId, required String gift}) async {
    if (points > currentQuestions.length / 2) {
      try {
        Map<String, dynamic> res = await DioHelper().postData(
             addWinner, data:  {"user_id": userId, "gift": gift});
        if (res['success'] == true) {
          Get.Get.snackbar(
            'مبروك',
            'مبروك كسبت $gift هيتم التواصل معك في اقرب وقت ',
            backgroundColor: Colors.green,
          );
          return true;
        } else {
          showErrorToast(res['message']);
        }
        return false;
      } catch (error) {
        debugMessage(error.toString());
        return false;
      }
    } else {
      Get.Get.snackbar(
        'خبر محزن',
        'للاسف لم تتجاوز الحد الادنى للفوز',
        backgroundColor: Colors.red,
      );
      return true;
    }
  }

  void addNewQuestion(QuestionModel questionModel) {
    currentQuestions.insert(quecnt + 1, questionModel);
    forceNextQuestion();
    notifyListeners();
  }

  Future getRandomQuestion() async {
    try {
      Map<String, dynamic> res = await DioHelper().getData(

            (isNotCompetation ? randomQuestions : competitionRandomQuestions) +
                categoryName,
      );
      log(res.toString());
      if (res['success'] == true) {
        randomQuestionAfterAds = QuestionModel.fromJson(res['result']);
        addNewQuestion(randomQuestionAfterAds!);
        notifyListeners();
        return true;
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }

  void increasePoints() {
    points++;
    debugMessage('points is : ' + points.toString());
  }

  bool checkIsCorrectAnswer() {
    return (selectedAnswer == currentQuestions[quecnt].answer);
  }
}
