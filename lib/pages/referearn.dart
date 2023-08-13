import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';

import '../widget/mytext.dart';

bool topBar = false;

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  @override
  Widget build(BuildContext context) {
    return buildViewPager();
  }

  buildViewPager() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: appBgColor,
        body: Column(
          children: [
            Stack(children: [
              Container(
                height: Get.height,
                width: MediaQuery.of(context).size.width,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getAppbar(),
                  buildBody(),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(title: "كود المشاركة");
  }

  buildBody() {
    String userShareCode = Provider.of<UserProvider>(context).currentUser!.referralCode!;
    return Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 20),
      Image.asset('assets/images/ic_share.png', height: 90),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Center(
          child: Text(
              "يمكنك دعوة اصدقاءك وربح النقاط من خلال الكود التالي",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ),
      ),
      const SizedBox(height: 30),
      DottedBorder(
        dashPattern: const [4, 4],
        strokeWidth: 1,
        color: white,
        child: Container(
          height: 50,
          width: 250,
          color: tabbarunselect,
          child: Center(
            child: MyText(
              title: userShareCode,
              size: 24,
              fontWeight: FontWeight.w600,
              colors: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: userShareCode));
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("تم نسخ الكود",style: Get.theme.textTheme.subtitle2,),backgroundColor: tabbarunselect,));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text("نسخ الكود", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: white)),
        ),
      ),
    ]);
  }

  buildShareIcon() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
              title: "Share to your friend by using these",
              size: 18,
              fontWeight: FontWeight.w500),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_fb.png"),
                  const SizedBox(height: 5),
                  MyText(
                      title: "Facebook", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_tw.png"),
                  const SizedBox(height: 5),
                  MyText(
                      title: "Twitter", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_gp.png"),
                  const SizedBox(height: 5),
                  MyText(
                      title: "Google +", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_line.png"),
                  const SizedBox(height: 5),
                  MyText(title: "Line", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_wp.png"),
                  const SizedBox(height: 5),
                  MyText(
                      title: "Whatsapp", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_sms.png"),
                  const SizedBox(height: 5),
                  MyText(title: "SMS", size: 14, fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
