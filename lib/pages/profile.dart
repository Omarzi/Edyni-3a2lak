import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/login.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/model/userModel.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/show_loading.dart';
import '../widget/cutom_button.dart';
import 'editprofile.dart';

bool topBar = false;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildProfile();
  }

  buildProfile() {
    return Consumer<UserProvider>(
      builder: (BuildContext context, loginProvider, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: appBgColor,
            body: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/dash_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(50.0, 50.0)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getAppbar(),
                      buildHeader(loginProvider.currentUser!),
                    ],
                  ),
                ]),
                buildData(loginProvider.currentUser!),
              ],
            ),
          ),
        );
      },

    );
  }

  getAppbar() {
    return AppBar(
      title: Text(
        "الصفحة الشخصية",
        style: GoogleFonts.poppins(
            color: white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
              child: Image.asset(
                "assets/images/ic_edit.png",
                width: 20,
              ),
            )),
      ],
    );
  }

  buildHeader(UserModel currentUser) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 10),
        currentUser.image!=null&&currentUser.image!=''?CircleAvatar(radius:60,backgroundImage: CachedNetworkImageProvider(Provider.of<UserProvider>(context).currentUser!.image!),):CircleAvatar(radius:60,backgroundImage: AssetImage('assets/images/ic_user_default.png', ),),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(currentUser.name??"Arjun Patel",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentUser.gold.toString(),
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),

              SizedBox(
                child: Image.asset(
                    "assets/images/ic_icons.png"),
                height: 30,
                width: 30,
              ),

            ],
          ),
        ),

        const SizedBox(height: 20),
        IntrinsicHeight(
          child: Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  Text(currentUser.quizzesPlayed!=null? currentUser.quizzesPlayed.toString():'19',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  Text("الاختبارات التي تم لعبها",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              ),
              const Spacer(),
              const VerticalDivider(
                color: white,
                thickness: 0.5,
              ),
              const Spacer(),
              Column(
                children: [
                  Text(currentUser.points!=null?currentUser.points.toString():"1600",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  Text("النقاط المكتسبه",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              ),
              const Spacer(),
            ],
          ),
        )
      ]),
    );
  }

  buildData(UserModel currentUser) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              const SizedBox(width: 20),
              const CircleAvatar(
                  minRadius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/ic_mail.png")),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("البريد الالكتروني",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textColorGrey)),
                  Text(currentUser.email!=''?currentUser.email!:"email@example.com",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const SizedBox(width: 20),
              const CircleAvatar(
                  minRadius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/ic_mobile.png")),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("رقم الهاتف",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textColorGrey)),
                  Text(currentUser.phone??"+91 7984859403",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black)),
                ],
              ),
            ],
          ),
          const Spacer(),
          CustomButton(onPressed: () async {
            showLoading();
            bool success = await Provider.of<UserProvider>(context,listen: false).deleteAccount();
            if(success)
              {
                hideLoading();
                Get.offAll(() => const Login());
              }
          },title: 'حذف الحساب',),
          const SizedBox(height: 30,)

        ],
      ),
    );
  }
}
