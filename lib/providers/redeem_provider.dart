import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart'as getx;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/utils/constant.dart';

import '../Theme/color.dart';
import '../common/constants/end_points.dart';
import '../common/helpers/dio_helper.dart';
import '../widget/show_loading.dart';

class RedeemProvider extends ChangeNotifier {



  Future sendRedeemRequest({required userId , required String gift , required String gold , required BuildContext context}) async {
    try {
      showLoading();
      Map<String, dynamic> res = await DioHelper().postData(
        redeemRequest + userId,
        data:  {
          "redeemGift": gift,
          "gold": gold
        },
      );
      hideLoading();
      log(res.toString());
      if (res['success'] == true) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          confirmBtnText: 'موافق',
            confirmBtnColor: primary,
          text: 'تم ارسال طلبك بنجاح , سيقوم المسئول بالتواصل معك',
          onConfirmBtnTap: (){getx.Get.back();  getx.Get.back();}
        );
        notifyListeners();
      }else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          confirmBtnText: 'موافق',
          confirmBtnColor: primary,
          text: res['message'],
        );
      }
    } catch (error) {
      hideLoading();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        confirmBtnColor: primary,
        confirmBtnText: 'موافق',
        text: error.toString(),
      );

      debugMessage('from catch'+ error.toString());
    }
  }
}