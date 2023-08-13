import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/pages/home.dart';
import 'package:quizapp/pages/level.dart';
import 'package:quizapp/providers/questions_provider.dart';
import 'package:quizapp/utils/ads_helper.dart';
import 'package:quizapp/widget/show_loading.dart';

import '../Theme/color.dart';
import '../providers/user_provider.dart';

class WrongQuestionAnswer extends StatefulWidget {
  final String title;

  const WrongQuestionAnswer({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<WrongQuestionAnswer> createState() => _WrongQuestionAnswerState();
}

class _WrongQuestionAnswerState extends State<WrongQuestionAnswer> {
  AdManager ads = AdManager();

  @override
  void initState() {
     ads.loadRewardedAd();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    QuestionsProvider questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
          ),
          content: questionsProvider.quecnt ==
                  questionsProvider.currentQuestions.length - 1
              ? const Text('لقد انهيت المستوي الان')
              : questionsProvider.wrongAnwerCount == 2 || isLastThreeQus(questionsProvider) ? const Text('عفوا لقد خسرت') : const Text('يمكنك المحاولة مرة اخري بعد مشاهدة الاعلان'),
          actions: [
            // if (questionsProvider.hasMoreQuestions())
            //   TextButton(
            //       onPressed: () {
            //         //questionsProvider.forceNextQuestion();
            //         Get.back();
            //       },
            //       child: const Text('السؤال التالى')),
            if (isLastThreeQus(questionsProvider))
              TextButton(
                onPressed: () async {
                  questionsProvider.timer!.cancel();
                  bool success = false;
                  UserProvider userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  if (questionsProvider.isNotCompetation) {
                    success = await userProvider.updateUserPoints(
                        points: questionsProvider.points);
                    if (success) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'لقد حصلت علي ${questionsProvider.points} نقطه ',
                        confirmBtnText: 'موافق',
                        confirmBtnColor: primary,
                        barrierDismissible: false,
                        onConfirmBtnTap: (){
                          Get.back();
                          Get.back();
                          Get.back();
                          Get.back();
                        }
                      );
                    }
                  } else {
                    Get.back();
                    Get.back();
                  }


                },
                child: const Text('انهاء المستوي'),
              ),
            if (!questionsProvider.hasMoreQuestions())
              TextButton(
                onPressed: () async {
                  questionsProvider.timer!.cancel();
                  bool success = false;
                  UserProvider userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  if (questionsProvider.isNotCompetation) {
                    success = await userProvider.updateUserPoints(
                        points: questionsProvider.points);
                    await userProvider.userLevelUp(
                        (((questionsProvider.points /
                                    questionsProvider.currentQuestions.length) *
                                100) >=
                            85),
                        questionsProvider.categoryName,
                        questionsProvider.currentCategoryLevel);


                  } else {
                    success = await questionsProvider.addNewWinner(
                        userId: userProvider.currentUser!.sId!,
                        gift: questionsProvider.levelGift);
                  }
                  if (success) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'لقد حصلت علي ${questionsProvider.points} نقاط ',
                        confirmBtnText: 'موافق',
                        confirmBtnColor: primary,
                        barrierDismissible: false,
                        onConfirmBtnTap: (){
                          Get.back();
                          Get.back();
                          Get.back();
                          Get.back();
                        }
                    );
                  }
                },
                child: const Text('انهاء المستوي'),
              ),

            if (questionsProvider.quecnt <=
                questionsProvider.currentQuestions.length - 3&& !isLastThreeQus(questionsProvider)&&questionsProvider.wrongAnwerCount != 2)
              TextButton(
                onPressed: () async {

                  questionsProvider.timer!.cancel();
                      showLoading();
                      await Future.delayed(const Duration(milliseconds: 1500));
                      hideLoading();
                      ads.showRewardedAd(context);
                      ads.disposeAds();
                      Get.back();
                      questionsProvider.wrongAnwerCount++;



                },
                child: const Text('مشاهدة الاعلان'),
              ),


            if (questionsProvider.wrongAnwerCount == 2)
            TextButton(
              onPressed: () async {

                questionsProvider.wrongAnwerCount = 0;
                questionsProvider.timer!.cancel();
                Get.back();
                Get.back();

              },
              child: const Text('انهاء المستوي'),
            ),

    //  {

    // QuickAlert.show(
    // context: context,
    // type: QuickAlertType.error,
    // title: 'اجابة خاطئة',
    // text: 'عفوا برجاء المحاولة مرة اخري',
    // confirmBtnText: 'موافق',
    // confirmBtnColor: primary,
    // barrierDismissible: false,
    // onConfirmBtnTap: () {

    // });
    // }
          ],
        ),
      ),
    );
  }
  
  
  bool isLastThreeQus(QuestionsProvider questionsProvider){
    return (questionsProvider.quecnt >=
        questionsProvider.currentQuestions.length - 3 &&
        questionsProvider.quecnt !=
            questionsProvider.currentQuestions.length - 1);
  }
}
