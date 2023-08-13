import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

/// REG EXP \\\
final RegExp regExpEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final RegExp regExpPw = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
final RegExp regexImage = RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
final RegExp regExpPhone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
final RegExp regExpName = RegExp('[a-zA-Z]',);
final RegExp conditionEegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
final RegExp numberRegExp = RegExp(r'\d');
final RegExp langEnRegExp = RegExp('[a-zA-Z]');
final RegExp langEnArRegExp = RegExp('[a-zA-Zء-ي]');
final RegExp langArRegExp = RegExp('[ء-ي]');
final RegExp yearRegExp = RegExp(r'^(\d{4}$)');
final RegExp arabicRegExp = RegExp("[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
final storage = GetStorage();
List? user ;

String? email() {
  return  GetStorage().read('email').toString();
}
String customerOrSupplierName='';
List<String> currentBrand=[];

String? password() {
  return GetStorage().read('password').toString();
}

String? getToken() {
  return GetStorage().read('token');
}

void showErrorToast(String msg){
  Fluttertoast.showToast(msg: msg,backgroundColor: Colors.red,);
}


void showSuccessToast(String msg){
  Fluttertoast.showToast(msg: msg,backgroundColor: Colors.green,);
}

