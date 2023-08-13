import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/providers/redeem_provider.dart';

import '../Theme/color.dart';
import '../providers/user_provider.dart';

class RedeemCardItem extends StatelessWidget {
  final int index ;
  final RedeemProvider redeemProvider ;
  const RedeemCardItem({Key? key ,required this.index , required this.redeemProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context , listen:  false).currentUser!.sId! ;
    int gold = Provider.of<UserProvider>(context , listen: false).currentUser!.gold! ;

    int pounds = (((10*(index+1)*5)~/2)*.4).toInt() ;
    int points = 10*10*((index+1)*5);
    return InkWell(
      onTap: () async {
        if(gold >= points) {
          await redeemProvider.sendRedeemRequest(userId: userId, gift: pounds.toString() , gold: points.toString(), context: context);
        }else{
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnText: 'موافق',
            confirmBtnColor: primary,
            text: 'عفوا عدد النقاط المتاحه لا تكفي',
          );
        }
      },
      child: Card(
        color: tabbarunselect,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        margin: const EdgeInsets.symmetric(horizontal: 16 , vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children:  [
              Text(
                '$points نقطه = $pounds جنيه ',
                style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
