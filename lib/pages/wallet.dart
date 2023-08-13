import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/providers/redeem_provider.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/myappbar.dart';

import 'cardItem.dart';

bool topBar = false;

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  @override
  Widget build(BuildContext context) {


    return buildViewPager();
  }

  buildViewPager() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBgColor,
      body: ChangeNotifierProvider(
        create: (context) => RedeemProvider(),
        child: Consumer<RedeemProvider>(
            builder: (context, redeemProvider, child) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [getAppbar(), buildRedeemLimit() , buildBody(redeemProvider: redeemProvider)],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(title: "المحفظه");
  }


  buildRedeemLimit() {
    int userPoints = Provider.of<UserProvider>(context , listen: false).currentUser!.points! ;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        alignment: AlignmentDirectional.center,
        child: Column(
          children: [

            Text('*الحد الاقصي للسحب الشهري : 5000 نقطه' ,  style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Provider.of<UserProvider>(context , listen: false).currentUser!.gold.toString(),
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

            // Text('* عدد النقاط المتاحه : $userPoints نقطه ' ,  style: GoogleFonts.poppins(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white)),
          ],
        ),

    );
  }

  buildBody({required RedeemProvider redeemProvider}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 180,
          child: ListView(
            children: List.generate(10, (index) =>  RedeemCardItem(index:  index,redeemProvider: redeemProvider,) ),
          ),
        ));
  }


}
