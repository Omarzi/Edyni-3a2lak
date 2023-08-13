
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import '../common/constants/end_points.dart';
import '../common/constants/variables-methods.dart';
import '../utils/constant.dart';

class AvatarProvider extends ChangeNotifier {

  List imageLink = [] ;
  Future getAvatarLinks() async {
    try {
      Map<String, dynamic> res = await DioHelper().getData( getAvatar );

      if (res['success'] == true) {
        List data = res['result'];
        if (data.isNotEmpty) {
          imageLink = [];


          for (var element in data) {
            imageLink.add(element);
          }

          debugMessage(imageLink.length.toString() + ' ------------------------------------------ ');

          notifyListeners();
          return true;
        } else {
          showErrorToast('عفوا لا يوجد صور الان');
          return false;
        }
      } else {
        showErrorToast(res['message']);
      }
      return false;
    } catch (error) {
      debugMessage('from catch' + error.toString());
      return false;
    }
  }
}
