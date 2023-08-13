import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/category.dart';
import 'package:quizapp/Pages/contest.dart';
import 'package:quizapp/Pages/level.dart';
import 'package:quizapp/Pages/profile.dart';
import 'package:quizapp/Pages/settings.dart';
import 'package:quizapp/Pages/wallet.dart';
import 'package:quizapp/Pages/leaderboard.dart';
import 'package:quizapp/Theme/config.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/common/constants/assets.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/pages/feedback.dart';
import 'package:quizapp/pages/login.dart';
import 'package:quizapp/pages/question_page/questions.dart';
import 'package:quizapp/pages/referearn.dart';
import 'package:quizapp/pages/spinwheel.dart';
import 'package:quizapp/providers/user_provider.dart';

import 'notification_screen.dart';

bool topBar = false;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: appBgColor,
        body: GestureDetector(
          onTap: (() => setState(() {
                topBar = false;
              })),
          child: Stack(
            children: [
              Container(
                height: 310,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/appbg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(50.0, 50.0)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getAppbar(), buildBody()],
              ),
              topBar ? getTopBar() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: Text(
        Config().appName,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      leading: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
            child: Image.asset(
              'assets/images/ic_home.png',
              width: 50,
              height: 50,
            ),
            onTap: () {
              debugPrint("Home click");
              setState(() {
                topBar = true;
              });
            },
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: GestureDetector(
            child: Image.asset(
              'assets/images/ic_bell.png',
              width: 40,
            ),
            onTap: () {
              debugPrint("Bell Click");
              Get.to(NotificationScreen());
            },
          ),
        ),
      ],
    );
  }

  buildBody() {
    String userName = Provider.of<UserProvider>(context).currentUser!.name!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
            child: Text("مرحبا بك",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
            child: Text(
              userName ,
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          getDashboard(),

          getBottom(),
        ]),
      ),
    );
  }

  getDashboard() {
    return SizedBox(
      height: Get.height*.44,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(

              height: Get.height*.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 15,
                  ),

                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Category(normalCat: true,)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/yellow_bg.png"),
                              fit: BoxFit.fill),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "الدخول الى",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    "الاقسام",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),

                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: Image.asset(
                                    'assets/images/right_arrow.png',
                                    height: 35.0,
                                    width: 50.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Category(normalCat: false,)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/red_bg.png"),
                              fit: BoxFit.fill),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("الدخول الى",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 18)),
                                  Text("المسابقات",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600)),

                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: Image.asset(
                                    'assets/images/right_arrow.png',
                                    height: 40.0,
                                    width: 55.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Questions(categoryId: '', levelId: '',categoryName: '',levelGift: '',levelNumber: '',normalLevelQuestions: false,isChallenge: true,)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/blue_bg.png"),
                              fit: BoxFit.fill),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("الدخول الى",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 18)),
                                  Text("التحديات",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600)),

                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: Image.asset(
                                    'assets/images/right_arrow.png',
                                    height: 40.0,
                                    width: 55.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  getBottom() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "اخري",
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: 70,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoard()));
                    },
                    child: Column(
                      children: [
                        // Image.asset(
                        //   'assets/images/level_lock.png',
                        //   height: 60,
                        // ),
                        Image.asset(leaderboardIcon,width: 60,height: 60,),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('المتصدرين',
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.3,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: Column(
                      children: [
                        Image.asset(profileIcon,width: 60,height: 60,),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('الصفحة الشخصية',
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              )),
              Container(
                color: Colors.grey,
                width: 0.3,
                height: 150,
              ),
              Expanded(
                  child: Column(
                children: <Widget>[

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Wallet()));
                      topBar = false;
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          walletIcon,
                          height: 60,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('المحفظة',
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.3,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(settingsIcon,width: 60,height: 60,),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('الإعدادات',
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              )),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }

  getTopBar() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: textBoxColor,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.elliptical(30.0, 30.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Instrucation()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset(feedbackIcon,width: 60,height: 60,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('رايك يهمنا',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )),
          Container(
            color: Colors.grey,
            width: 0.3,
            height: 150,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReferEarn()));
                  topBar = false;
                  setState(() {});
                },
                child: Column(
                  children: [
                    Image.asset(
                      shareIcon,
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('شير و اكسب',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.grey,
                height: 0.3,
                width: 100,
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Provider.of<UserProvider>(context,listen: false).logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                  topBar = false;
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      logoutIcon,
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('الخروج',
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
