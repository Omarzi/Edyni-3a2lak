class ResponseErrorHelper{
  String getErrorsMessageFromJson(Map<String,dynamic> jsonFile){
    if (jsonFile.containsKey("errors")){
      return _getErrorMessageFromMapOfErrors(jsonFile["errors"]);
    }
    else{
      return jsonFile["message"];
    }
  }

  String _getErrorMessageFromMapOfErrors(Map<String,dynamic> errorsMap){
    String errorsMessage="";
    errorsMap.forEach(
          (key, value) {
        for (int i = 0; i < value.length; i++) {
          errorsMessage += value[i] + "\n";
        }
      },
    );
    errorsMessage = errorsMessage.substring(0,errorsMessage.length-1);
    return errorsMessage;
  }
}