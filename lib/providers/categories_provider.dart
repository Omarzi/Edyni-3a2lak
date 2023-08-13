import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/model/categorymodel.dart';
import 'package:quizapp/utils/constant.dart';

class CategoriesProvider extends ChangeNotifier {


  List<CategoryModel>? currentCategories;
  Future getAllCategories({required String? normalCat, required String? competitionCat,}) async {

    try {

      Map<String, dynamic> res = await DioHelper().getData( normalCat ?? competitionCat!, );
      log(res.toString());
      if(res['success']==true)
      {
        currentCategories=[];
        List data = res['result'];

            data.forEach((element){
              currentCategories!.add(CategoryModel.fromJson(element));
            });
            debugMessage(currentCategories!.length.toString()+' length');

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
