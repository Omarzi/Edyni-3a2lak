import 'package:flutter/foundation.dart';

void debugMessage (String msg){
  if(kDebugMode)
    {
      print(msg);
    }
}

String correctVerificationCode = '';