
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/model/notification_model.dart';

import '../common/constants/variables-methods.dart';
import '../common/helpers/dio_helper.dart';
import '../utils/constant.dart';

class NotificationProvider with ChangeNotifier {

    List<NotificationModel> notifications=[];

    Future getAllNotifications()async{
      try {

        Map<String, dynamic> res = await DioHelper().getData( notification, );
        log(res.toString());
        if(res['success']==true)
        {
          notifications=[];
          List data = res['result'];

          data.forEach((element){
            notifications.add(NotificationModel.fromJson(element));
          });

          notifyListeners();

        }else {
          showErrorToast(res['message']);
        }

      }catch (e) {
        debugMessage(e.toString());
      }
    }
}
