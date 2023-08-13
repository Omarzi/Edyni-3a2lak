import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/model/userModel.dart';
import 'package:quizapp/utils/constant.dart';

import '../common/constants/end_points.dart';

class LeaderboardProvider extends ChangeNotifier {


  List<UserModel> leaderBoardUsers=[];
  Future getLeaderBoard() async {

    try {

      Map<String, dynamic> res = await DioHelper().getData( rank, );
      log(res.toString());
      if(res['success']==true)
      {
        leaderBoardUsers=[];
        List data = res['result']['users'];

        data.forEach((element){
          leaderBoardUsers.add(UserModel.fromJson(element));
        });
        debugMessage(leaderBoardUsers.length.toString()+' length');

        notifyListeners();
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
