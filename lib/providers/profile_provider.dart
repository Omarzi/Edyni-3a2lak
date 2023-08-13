import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/utils/constant.dart';

class ProfileProvider extends ChangeNotifier {

  bool uplodaingImage = false;
  Future updateProfileImage({required String userId,required String imgLink}) async {

    try {
      Map<String,dynamic> data = {};
      data['id']=userId;
      data['image']=imgLink;
      Map<String, dynamic> res = await DioHelper().postData( profileImageUpdate,data:  data);
      if(res['msg']=="User Image Updated Successfully")
      {
        showSuccessToast("تم تحديث الصورة الشخصية بنجاح");
        return true;
      }else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }

  }



  setStateManual()
  {
    notifyListeners();
  }

  Future<bool> updateProfileData({
    required String username,
    required String phone,
    required String email,
    required String userId
  }) async {
    try {
      Map<String,dynamic> data = {};
      data['id']=userId;
      data['email']=email;
      data['name']=username;
      data['phone']=phone;

      Map<String, dynamic> res = await DioHelper().postData(profileUpdate, data:  data );

      if(res['msg']=="Profile Updated Successfully")
        {
          showSuccessToast("تم تحديث الملف الشخصي بنجاح");
          return true;
        }else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
        debugMessage(error.toString());
        return false;
    }
  }
}
