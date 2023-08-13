import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/common/helpers/exception_helper.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:quizapp/widget/show_loading.dart';

class RegisterProvider extends ChangeNotifier {


  Future verifyPhone(String phone) async {
    correctVerificationCode = '';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential phoneCredincial) {
          debugMessage('phone verified');
        },
        verificationFailed: (FirebaseAuthException err) {
          showErrorToast('تم حظر هذا الرقم مؤقتا لارساله طلبات كثيرة ');
          debugMessage('phone not verified ----> ${err.toString()}');
        },
        codeSent: (String verCode, int? reset) {
          debugMessage(verCode);
          correctVerificationCode = verCode;
        },
        codeAutoRetrievalTimeout: (val) {});
  }
  Timer timer = Timer(const Duration(seconds: 0), () {});
  int percent=120;
  bool canBack=true;

  startTimer()
  {

    log('timer is active ${timer.isActive.toString()}');
    percent=120;
    canBack=false;
    timer = Timer.periodic(const Duration(milliseconds: 1000) ,(_) {
      percent--;
      log('Started New Timer $percent');
      if (percent <=0) {
        timer.cancel();
        percent = 0;
        canBack=true;
      }
      notifyListeners();
    });

    log('timer is active ${timer.isActive.toString()}');
  }

  bool verified = false;
  Future verifyOTP(String userCode) async {
    showLoading();
    verified = false;
    debugMessage(correctVerificationCode);
    try
        {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: correctVerificationCode, smsCode: userCode);
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(credential);
          verified = (userCredential.user!=null);
          hideLoading();
        }on FirebaseAuthException {
      showErrorToast('الكود الذي ادخلتة تم انتهاءه');
      hideLoading();
    }catch(e)
    {
      showErrorToast(e.toString());
      hideLoading();
    }
  }

  bool accountCreated = false;
  String userId='';
  Future createUser({required String name,required String phone,required String password,required String? email,required String? referral})async{
    accountCreated= false;

    try {
      log({
        'name': name,
        'phone': phone,
        'password': password,
        'email': email ?? '',
        'referral_code': referral ?? ''
      }.toString());
      Map<String, dynamic> res = await DioHelper().postData( register,
          data:  {
            'name': name,
            'phone': phone,
            'password': password,
            'email': email ?? '',
            'referral_code': referral ?? ''
          });
      if (res['success'] == true) {
        showSuccessToast('تم تسجيل الحساب بنجاح');
        accountCreated = true;
        userId = res['result']['_id'];
        notifyListeners();
      } else {
        showErrorToast(res['message'].toString());
      }
    }on ServerException catch(e)
    {
      showErrorToast(e.toString());
    }catch(e){
      log(e.toString());
      log((e is ServerException).toString());
      //showErrorToast(e.toString());
    }
  }
}
