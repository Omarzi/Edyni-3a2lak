import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quizapp/Pages/home.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/model/userModel.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:quizapp/widget/show_loading.dart';

import '../Theme/color.dart';
import '../common/constants/variables-methods.dart';
import '../common/helpers/dio_helper.dart';
import '../main.dart';

class UserProvider extends ChangeNotifier {
  UserModel? currentUser;

  Future<bool> refreshUserData() async {
    try {
      String? token = getToken();
      log(token.toString());
      if (token != null) {
        Map<String, dynamic> res = await DioHelper().postData(checkToken,
            options: Options(headers: {'Authorization': token}));

        if (res['success'] == true) {
          currentUser = UserModel.fromJson(res['result']);
          debugMessage(' --------  refresed user data --------\n' +
              currentUser!.toJson().toString());
          //showSuccessToast('تم تسجيل الدخول بنجاح');
          await getDailyLoginPoints(userId: currentUser!.sId!);
          notifyListeners();
          return true;
        }
      }

      return false;
    } catch (e) {
      debugMessage(e.toString() + ' from catch');
      return false;
    }
  }

  Future login({required String phone, required String pass}) async {
    try {
      Map<String, dynamic> res =
          await DioHelper().postData(loginEndPoint, data: {
        'phone': phone,
        'password': pass,
      });
      if (res['success'] == true) {
        currentUser = UserModel.fromJson(res['result']['user']);
        await GetStorage().write('token', res['token']);
        showSuccessToast('تم تسجيل الدخول بنجاح');
        await getDailyLoginPoints(userId: currentUser!.sId!);
        notifyListeners();
      } else {
        showErrorToast('من فضلك التاكد من رقم الهاتف وكلمة المرور');
      }
    } catch (e) {
      debugMessage(e.toString());
      showErrorToast(e.toString());
    }
  }

  int day = 0;

  Future getDailyLoginPoints({required String userId}) async {
    try {
      Map<String, dynamic> res =
          await DioHelper().getData(getDailyPoints + userId);

      if (res['result'] != null) {
        day = res['result'];

        updateUserPoints(points: day * 10).then((value) {
          Future.delayed(const Duration(milliseconds: 500))
              .then((value) => QuickAlert.show(
                  context: navigatorKey.currentState!.overlay!.context,
                  type: QuickAlertType.success,
                  title: 'مبروك',
                  text: 'لقد حصلت علي ${day * 10} نقاط مجانا',
                  confirmBtnText: 'الرجوع الى الشاشه الرئيسيه',
                  confirmBtnColor: primary,
                  barrierDismissible: false,
                  onConfirmBtnTap: () {
                    Get.offAll(const Home());
                  }));
          //showSuccessToast('مبروك لقد حصلت علي ${day*10} نقاط مجانا ');
        });

        notifyListeners();
        return true;
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      String? token = getToken();
      if (token != null) {
        Map<String, dynamic> res = await DioHelper()
            .delData(deleteUserAccount, {'userId': currentUser!.sId}, token);

        if (res['success'] == true) {
          showSuccessToast("تم حذف الحساب بنجاح");
          logout();
          return true;
        } else {
          showErrorToast(res['message']);
        }
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }

  Future<void> logout() async {
    currentUser = null;
    await GetStorage().remove('token');
  }

  Future updateUserPoints({required int points}) async {
    try {
      showLoading();
      Map<String, dynamic> res = await DioHelper().patchData(
        path: updatePoints + '/${currentUser!.sId}',
        data: {'points': points},
      );
      hideLoading();
      log(res.toString());
      if (res['success'] == true) {
        currentUser = UserModel.fromJson(res['result']);
        notifyListeners();
        return true;
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      hideLoading();
      debugMessage(error.toString());
      return false;
    }
  }

  Future userLevelUp(
      bool canLevelUp, String categoryName, int categoryLevel) async {
    if (canLevelUp) {
      try {
        showLoading();
        Map<String, dynamic> res = await DioHelper().patchData(
          path: levelUp + currentUser!.sId!,
          data: {'level': categoryLevel, "category": categoryName.trim()},
        );
        hideLoading();
        log(res.toString());
        if (res['success'] == true) {
          currentUser = UserModel.fromJson(res['result']);
          notifyListeners();
          return true;
        } else {
          showErrorToast(res['message']);
        }
        return false;
      } catch (error) {
        hideLoading();
        debugMessage(error.toString());
        return false;
      }
    }
  }

  Future decrementUserPoints({required int points}) async {
    try {
      showLoading();
      Map<String, dynamic> res = await DioHelper().patchData(
        path: decrementPoints + '/${currentUser!.sId}',
        data: {'points': points},
      );
      hideLoading();
      log(res.toString());
      if (res['success'] == true) {
        currentUser = UserModel.fromJson(res['result']);
        notifyListeners();
        return true;
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      hideLoading();
      debugMessage(error.toString());
      return false;
    }
  }
}
