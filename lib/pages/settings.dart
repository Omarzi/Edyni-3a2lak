import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/aboutUs.dart';
import 'package:quizapp/Pages/privacyPolicy.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/theme/color.dart';
import 'package:quizapp/widget/myText.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/rate_app_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = true;

  @override
  void initState() {
    super.initState();

    String platformType = Platform.operatingSystem;

    RateAppProvider rateAppProvider =  Provider.of<RateAppProvider>(context , listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      rateAppProvider.getStoreLink(platform: platformType);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: getAppbar(),
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [const SizedBox(height: 30), buildBody()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: const Text(
        "الإعدادات",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          // menuItem('Change ')
          menuItem("من نحن"),
          menuItem("سياسه الخصوصيه"),
          menuItem("قيم التطبيق"),
        ]),
      ),
    );
  }

  Future<void> _launchUrl({required String link}) async {
    if (!await launchUrl(Uri.parse(link))) {
      throw 'Could not launch ${Uri.parse(link)}';
    }
  }

  menuItem(String title) {

    return GestureDetector(
      onTap: () {
        if (title == 'من نحن') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AboutUs()));
        } else if (title == "سياسه الخصوصيه") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
        }
        else if (title == "قيم التطبيق") {
          RateAppProvider rateAppProvider =  Provider.of<RateAppProvider>(context , listen: false);

          if(rateAppProvider.link != '') {
            _launchUrl(link: rateAppProvider.link) ;
          }
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              MyText(title: title, size: 14, fontWeight: FontWeight.w600,colors: Colors.black),
              const Spacer(),
              if (title == 'Push Notification' ||
                  title == 'Enable Sound' ||
                  title == 'Enable Vibration')
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                )
              else
                const Icon(Icons.arrow_forward_ios , color:Colors.black, size: 15,)
                //Image.asset("assets/images/ic_right_arrow.png", height: 15),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 0.5, color: textColorGrey),
        ],
      ),
    );
  }
}
