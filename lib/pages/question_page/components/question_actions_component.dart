import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/pages/level.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Theme/color.dart';
import '../../../providers/questions_provider.dart';
import '../../../widget/myText.dart';
import '../../../widget/wrong_question_answer.dart';
import '../../home.dart';
class QuestionActionsComponent extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const QuestionActionsComponent({Key? key, required this.categoryId,required this.categoryName})
      : super(key: key);

  @override
  State<QuestionActionsComponent> createState() =>
      _QuestionActionsComponentState();
}

class _QuestionActionsComponentState extends State<QuestionActionsComponent> {

  @override
  Widget build(BuildContext context) {
    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(
        context);
    UserProvider userProvider = Provider.of<UserProvider>(
        context,listen: false);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: TextButton(
                  onPressed: () async {
                    if (questionsProvider.quecnt < questionsProvider.currentQuestions.length - 1) {
                      if(!questionsProvider.isChallenge)
                        {
                          if (questionsProvider.checkIsCorrectAnswer()) {
                            questionsProvider.increasePoints();
                            questionsProvider.wrongAnwerCount=0;
                            questionsProvider.nextQuestion();
                          } else {
                            Get.dialog(const WrongQuestionAnswer(title: 'اجابة خاطئة',));
                          }
                        }else
                          {
                            if (questionsProvider.checkIsCorrectAnswer()) {
                              questionsProvider.increasePoints();
                            }
                            questionsProvider.nextQuestion();
                          }
                      questionsProvider.resetTimer('question actions');
                    } else {
                      if (questionsProvider.checkIsCorrectAnswer()) {
                        questionsProvider.increasePoints();
                        if(!questionsProvider.isChallenge)
                          {
                            File img = await saveShareImage();
                            QuickAlert.show(context: context,
                                type: QuickAlertType.success,
                                title: 'اجابة صحيحة',
                                text: 'مبروك لقد انهيت المستوي بنجاح',
                                confirmBtnText: 'انهاء',
                                confirmBtnColor: primary,
                                cancelBtnText: 'مشاركة',
                                showCancelBtn: true,
                                onCancelBtnTap: () async {
                                  bool success =false;
                                  UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
                                  if(questionsProvider.isNotCompetation) {
                                    success = await userProvider.updateUserPoints( points: questionsProvider.points);
                                    await userProvider.userLevelUp((((questionsProvider.points/questionsProvider.currentQuestions.length)*100)>=85),widget.categoryName,questionsProvider.currentCategoryLevel);
                                  } else {
                                    success = await questionsProvider.addNewWinner(userId: userProvider.currentUser!.sId!, gift: questionsProvider.levelGift);
                                  }
                                  if(success&&questionsProvider.isNotCompetation) {
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
                                          // Get.back();
                                        }
                                    );
                                  }
                                  Share.shareXFiles([XFile(img.path)], text: 'انجاز جديد',subject: subjectString(questionsProvider.isNotCompetation,questionsProvider.levelGift,questionsProvider.points.toString()) );
                                },
                                barrierDismissible: false,
                                onConfirmBtnTap: () async {
                                  bool success =false;
                                  UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
                                  if(questionsProvider.isNotCompetation) {
                                    success = await userProvider.updateUserPoints( points: questionsProvider.points);
                                    await userProvider.userLevelUp((((questionsProvider.points/questionsProvider.currentQuestions.length)*100)>=85),widget.categoryName,questionsProvider.currentCategoryLevel);
                                  } else {
                                    success = await questionsProvider.addNewWinner(userId: userProvider.currentUser!.sId!, gift: questionsProvider.levelGift);
                                  }
                                  if(success&&questionsProvider.isNotCompetation) {
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
                                          // Get.back();
                                        }
                                    );
                                  }
                                }
                            );
                          }else
                            {
                              await questionsProvider.sendChallengeWinner(userId:userProvider.currentUser!.sId.toString() );
                              QuickAlert.show(context: context,
                                  type: QuickAlertType.success,
                                  title: 'مبروك',
                                  text: ' مبروك كسبت ${questionsProvider.challengeGift} ',
                                  confirmBtnText: 'الرجوع الى المستويات',
                                  confirmBtnColor: primary,
                                  barrierDismissible: false,
                                  onConfirmBtnTap: () async {
                                    Get.offAll(const Home());
                                  }
                              );
                            }
                      } else {

                        if(!questionsProvider.isChallenge)
                          {
                            Get.dialog(
                                const WrongQuestionAnswer(title: 'اجابة خاطئة',));
                          }else
                            {
                              await questionsProvider.sendChallengeWinner(userId:userProvider.currentUser!.sId.toString() );
                              QuickAlert.show(context: context,
                                  type: QuickAlertType.success,
                                  title: 'مبروك',
                                  text: 'مبروك لقد انهيت التحدي بنجاح',
                                  confirmBtnText: 'الرجوع الى المستويات',
                                  confirmBtnColor: primary,
                                  barrierDismissible: false,
                                  onConfirmBtnTap: () async {
                                      Get.offAll(const Home());
                                  }
                              );
                            }
                      }
                      questionsProvider.timer!.cancel();
                    }
                  },
                  child: MyText(
                    title: "اختيار",
                    colors: white,
                    fontWeight: FontWeight.bold,
                    size: 18,
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(
                          primary),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  25.0),
                              side: const BorderSide(
                                  color: primary))))),
            ),
          ),

        ],
      ),
    );
  }



  Future<File> saveShareImage()
  async {
    final ByteData bytes = await rootBundle.load('assets/images/winner.jpg');
    final Uint8List list = bytes.buffer.asUint8List();
    final directory = (await getExternalStorageDirectory())!.path;
    File imgFile = File('$directory/winner.jpg');
    imgFile.writeAsBytesSync(list);
    return imgFile;
  }

  String subjectString (bool isCompetetion,String? gift, String? points)
  {
    return !isCompetetion? 'لقد حققت انجاز جديد و ربحت $gift': 'لقد حققت انجاز جديد و ربحت $points نقطة ';
  }
}
