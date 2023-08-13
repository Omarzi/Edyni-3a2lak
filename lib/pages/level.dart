import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/pages/question_page/questions.dart';
import 'package:quizapp/providers/levels_provider.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import '../Theme/color.dart';
import '../model/level_model.dart';
import '../providers/questions_provider.dart';
import '../utils/ads_helper.dart';
import '../widget/show_loading.dart';
import 'category.dart';

class Level extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final bool normalLevels;

  const Level(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.normalLevels})
      : super(key: key);

  @override
  _LevelState createState() => _LevelState();
}

class _LevelState extends State<Level> {
  AdManager ads = AdManager();

  @override
  void initState() {
    LevelsProvider levelsProvider =
        Provider.of<LevelsProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.currentUser!.level = -1;
    log('user level set to -1');

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List data = await Future.wait([
        levelsProvider.getCategoryLevels(
            categoryId: widget.categoryId,
            competitionLevelsPath:
                widget.normalLevels ? null : competitionLevels,
            normalLevelPath: widget.normalLevels ? categoryLevels : null),
        levelsProvider.getUserCategoryLevel(
            categoryName: widget.categoryName,
            userId: userProvider.currentUser!.sId!)
      ]);
      await ads.loadRewardedAd();
      userProvider.currentUser!.level = data.last as int;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    LevelsProvider levelsProvider =
        Provider.of<LevelsProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return FocusDetector(
      onVisibilityGained: () {
        levelsProvider
            .getUserCategoryLevel(
                categoryName: widget.categoryName,
                userId: userProvider.currentUser!.sId!)
            .then((value) {
          userProvider.currentUser!.level = value;
          setState(() {});
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.vertical(bottom: Radius.elliptical(50.0, 50.0)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: MyAppbar(
                title: "اختار المستوي",
              ),
            ),
            body: buildBody(levelsProvider.currentLevels, userProvider),
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: const Text(
        "Select Level",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  buildBody(List<LevelModel> levels, UserProvider userProvider) {
    log('current category user level is ${userProvider.currentUser!.level.toString()}');
    return levels.isNotEmpty
        ? Consumer<LevelsProvider>(
            builder: (context, levelsProvider, child) {
              if (userProvider.currentUser!.level == -1) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primary,
                ));
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: levels.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (widget.normalLevels) {
                                    if (userProvider.currentUser!.level! - 1 >=
                                        index) {
                                      showLoading();
                                      await Future.delayed(
                                          const Duration(milliseconds: 1500));
                                      hideLoading();
                                      ads.showRewardedAd(context);
                                      //ads.disposeAds();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Questions(
                                                    currentCategoryLevel:
                                                        userProvider
                                                            .currentUser!.level,
                                                    levelGift: levelsProvider
                                                            .currentLevels[
                                                                index]
                                                            .gift ??
                                                        '',
                                                    categoryName:
                                                        widget.categoryName,
                                                    normalLevelQuestions:
                                                        widget.normalLevels,
                                                    categoryId:
                                                        widget.categoryId,
                                                    levelNumber: levels[index]
                                                        .number
                                                        .toString(),
                                                    levelId: levels[index].sId!,
                                                  )));
                                    } else {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        title: 'عفوا',
                                        text: 'يجب تخطي المستوي السابق اولا',
                                        confirmBtnText: 'موافق',
                                        confirmBtnTextStyle: Get.textTheme.subtitle1!
                                            .copyWith(color: Colors.white),
                                        confirmBtnColor: primary,
                                        barrierDismissible: false,
                                      );
                                    }
                                  } else if (!widget.normalLevels &&
                                      userProvider.currentUser!.gold! >=
                                          levelsProvider.currentLevels[index]
                                              .minPoints!) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title: 'تنبيه !!',
                                      text:
                                          'سوف يتم خصم ${levelsProvider.currentLevels[index].minPoints!} نقط لدخول هذا المستوي ',
                                      confirmBtnColor: primary,
                                      confirmBtnText: 'موافق',
                                      cancelBtnText: 'الرجوع',
                                      barrierDismissible: false,
                                      onConfirmBtnTap: () {
                                        Get.back();
                                        userProvider
                                            .decrementUserPoints(
                                                points: levelsProvider
                                                    .currentLevels[index]
                                                    .minPoints!)
                                            .then((value) {
                                          showSuccessToast(
                                              'تم خصم ${levelsProvider.currentLevels[index].minPoints!} نقطه بنجاح ');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Questions(
                                                        levelGift: levelsProvider
                                                                .currentLevels[
                                                                    index]
                                                                .gift ??
                                                            '',
                                                        categoryName:
                                                            widget.categoryName,
                                                        normalLevelQuestions:
                                                            widget.normalLevels,
                                                        categoryId:
                                                            widget.categoryId,
                                                        levelNumber:
                                                            levels[index]
                                                                .number
                                                                .toString(),
                                                        levelId:
                                                            levels[index].sId!,
                                                      )));
                                        });
                                      },
                                      onCancelBtnTap: () {
                                        Get.back();
                                      },
                                      showCancelBtn: true,
                                    );
                                  } else {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      title: 'عفوا',
                                      text:
                                          'عدد العملات لديك لا تكفي لدخول المستوي',
                                      confirmBtnText: 'جمع العملات',
                                      confirmBtnTextStyle: Get
                                          .textTheme.subtitle1!
                                          .copyWith(color: Colors.white),
                                      cancelBtnText: 'الرجوع',
                                      confirmBtnColor: primary,
                                      barrierDismissible: false,
                                      onConfirmBtnTap: () {
                                        Get.back();
                                        Get.to(const Category(
                                          normalCat: true,
                                        ));
                                      },
                                      onCancelBtnTap: () {
                                        Get.back();
                                      },
                                      showCancelBtn: true,
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Image(
                                              image: NetworkImage(
                                                  levels[index].image!),
                                              fit: BoxFit.contain,
                                              width: Get.width,
                                            )),
                                        flex: 10,
                                      ),
                                      Expanded(
                                        child: MyText(
                                            title:
                                                'المستوي ${levels[index].number}',
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                            colors: textColor),
                                      ),
                                      Expanded(
                                        child: MyText(
                                            title:
                                                'عدد الاسئلة ${levels[index].question!.length}',
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                            colors: textColor),
                                      ),
                                      if (levels[index].gift != null)
                                        Expanded(
                                          child: MyText(
                                              title:
                                                  'الجائزة ${levels[index].gift}',
                                              size: 16,
                                              maxline: 2,
                                              fontWeight: FontWeight.w500,
                                              colors: textColor),
                                        ),
                                    ],
                                  ),
                                  height: Get.height * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 1.0,
                                        ),
                                      ]),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(
              color: primary,
            ),
          );
  }
}
