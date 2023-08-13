import 'package:get/get.dart';
import 'package:quizapp/providers/register_provider.dart';
import 'package:quizapp/widget/show_loading.dart';

import '../Pages/login.dart';
import '../common/constants/end_points.dart';
import '../common/constants/variables-methods.dart';
import '../common/helpers/dio_helper.dart';
import '../utils/constant.dart';

class ForgetPasswordProvider extends RegisterProvider
{

  Future forgetPassword({required String phone, required String pass}) async {
    try {
      showLoading();
      Map<String, dynamic> res =
      await DioHelper().postData(forgetPass, data: {
        'phone': phone,
        'password': pass,
      });
      hideLoading();
      if (res['success'] == true) {
        //showSuccessToast(res['message']);
        showSuccessToast('تم استرداد حسابك  بنجاح');
        Get.offAll(const Login());
        notifyListeners();
      } else {
        showErrorToast(res['message']);
      }
    } catch (e) {
      debugMessage(e.toString());
      showErrorToast(e.toString());
    }
  }
}