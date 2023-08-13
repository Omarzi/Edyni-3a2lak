import 'package:flutter/material.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import '../common/constants/end_points.dart';
import '../common/constants/variables-methods.dart';
import '../utils/constant.dart';

class RateAppProvider extends ChangeNotifier {

  String link = '' ;
  Future getStoreLink({required String platform}) async {
    try {
      Map<String, dynamic> res = await DioHelper().getData( rateApp + platform,);

      if (res['success'] == true) {
        Map<String, dynamic> data = res['result'];
        if (data.isNotEmpty) {

          if(platform == 'android') {
            link =  data['googleLink'].toString() ;
            debugMessage('rate app link is = ' + data['googleLink'].toString());
          }else if(platform == 'ios')
            {
              link =  data['appleLink'].toString() ;
            }
          notifyListeners();
          return true;
        } else {
          showErrorToast('عفوا لا يوجد تقييم الان');
          return false;
        }
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage(error.toString());
      return false;
    }
  }
}
