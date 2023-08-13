import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/model/level_model.dart';
import 'package:quizapp/utils/constant.dart';

import '../common/constants/end_points.dart';

class LevelsProvider extends ChangeNotifier {

  List<LevelModel> currentLevels=[];
  Future getCategoryLevels({required String categoryId,required String? normalLevelPath,required String? competitionLevelsPath,}) async {

    try {
      Map<String, dynamic> res = await DioHelper().getData((normalLevelPath ?? competitionLevelsPath!)+'/$categoryId', );
      log(res.toString());
      if(res['success']==true)
      {
        List data = res['levels'];
        currentLevels=[];
            data.forEach((element){
              currentLevels.add(LevelModel.fromJson(element));
            });
            debugMessage(currentLevels[0].minPoints.toString()+' length');

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


  Future<int> getUserCategoryLevel({required String categoryName,required String userId,}) async {
    log('calling getUserCategoryLevel');
    log('category name is $categoryName');
    try {
      Map<String, dynamic> res = await DioHelper().postData(userCategoryLevel+userId,data: {"category":categoryName.trim()} );
      log(res.toString());
      if(res['success']==true)
      {
        log('calling getUserCategoryLevel success');
        return  res['result']['level'];
      }else {
        showErrorToast(res['message']);
      }
      log('calling getUserCategoryLevel faild');
      return -1;
    } catch (error) {
      log('calling getUserCategoryLevel failed catch');
      log(error.toString());
      debugMessage(error.toString());
      return -1;
    }

  }




}
