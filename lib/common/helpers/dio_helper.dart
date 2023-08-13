import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'package:quizapp/common/helpers/error_helper.dart';
import 'package:quizapp/common/helpers/exception_helper.dart';

import '../../utils/constant.dart';




class DioHelper
{
  static String baseUrl = 'https://api.gmind.app/api/';
  static String api = baseUrl;




  final ResponseErrorHelper responseErrorHelper = ResponseErrorHelper();
  Dio dio = Dio(
    BaseOptions(
      baseUrl:  baseUrl,
    ),
  );
  DioHelper(){
    _fixCertificateProblem();
  }
  void _fixCertificateProblem(){
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }


  Future<dynamic> postDataWithoutToken(String parameter, {dynamic data}) async
  {
    final response = await dio.post( parameter,
        data: data ,
        options: Options(
          method: 'POST',
          validateStatus: (state) => state! < 500,
          // followRedirects: false,
          // validateStatus: (status) => true,
        )
    );
    return handleResponse(response);
  }


  Future<dynamic> postData(String parameter, {dynamic data,Options? options}) async
  {
    debugMessage(parameter);
    debugMessage(data.toString());
    final response = await dio.post(
      parameter,
      data: data,
      options: options ??
          Options(
            contentType: 'application/json',
            method: 'POST',
            validateStatus: (state) => state! < 500,
          ),
    );
    return handleResponse(response);
  }


  // Future<dynamic> postDataWithFormData(String parameter, dynamic data,) async
  // {
  //   log(data.toString());
  //   FormData formData = FormData.fromMap(data,/*ListFormat.multiCompatible*/);
  //   return postData(parameter, formData,
  //     options: Options(
  //       headers: {
  //         // 'content-Type': 'application/json',
  //         'Content-Type': 'multipart/form-data;charset=UTF-8',
  //         'Charset': 'utf-8'
  //       },
  //       method: 'POST',
  //       validateStatus: (state) => state! < 500,
  //     ),
  //   );
  // }


  Future<dynamic> postWithoutDataWithToken(String parameter, String bearerToken) async
  {

    debugMessage(parameter);
    debugMessage(Options(
      headers: {'Authorization': bearerToken},
      contentType: 'application/json',
      method: 'POST',
      validateStatus: (state) => state! < 500,
    ).headers.toString());
    final response = await dio.post(parameter,);
    return handleResponse(response);
  }


  Future<dynamic> putData(String parameter, Map<String, dynamic> data,) async
  {

    final response = await dio.put(parameter,
        data: json.encoder.convert(data),
        options: Options(
          contentType: 'application/json',
          method: 'PUT',
          validateStatus: (state) => state! < 500,
        ));
    return handleResponse(response);
  }

  Future<Map<String, dynamic>> delData(String parameter, Map<String, dynamic>? query, String token) async
  {

    final response = await dio.delete(parameter,
        queryParameters: query ,
        options: Options(
          headers: {'Authorization':token},
          contentType: 'application/json',
          method: 'DEL',
          validateStatus: (state) => state! < 500,
        ));

    return handleResponse(response);
  }

  Future<Map<String,dynamic>> getDataWithoutToken(String parameter) async
  {
    Response response = await dio.get(parameter);
    return handleResponse(response);
  }

  Future<dynamic> getData(String parameter) async
  {
    debugMessage(parameter);
    Response response = await dio.get(parameter,);
    return handleResponse(response);
  }

  Future<dynamic> getDataWithBody(String endPoint,Map<String,dynamic> body) async
  {
    log(endPoint+'  ${body.toString()}');
    Response response = await dio.get(endPoint,queryParameters:body );
    return handleResponse(response);
  }


   Future<dynamic> patchData(
      {
        required String path,
        Map<String, dynamic>? query,
        required data,

      }) async {

    Response res = await dio.patch(
      path,
      data:data,
      queryParameters: query,
    );

    return handleResponse(res);
  }



  dynamic handleResponse(Response response){
    // log(response.statusCode.toString());
    // log(response.data.toString());
    if(response.statusCode.toString()[0] != "2"){
      log(response.data.toString());
      String message = responseErrorHelper.getErrorsMessageFromJson(response.data);
      throw ServerException(exceptionMessage: message,);
    }
    return response.data ;
  }
}




// class DioHelper {
//   static final ResponseErrorHelper responseErrorHelper = ResponseErrorHelper();
//   static Dio dio=Dio(BaseOptions(
//     baseUrl: 'https://api.gmind.app/api/',
//   ),
//   );
//
//
//
//
//
//   static Future<Map<String, dynamic>> getData(
//       {
//         required String path,
//         Map<String, dynamic>? query,
//         bool? isEmailAndPasswordRequired,
//
//       }) async {
//     log(dio.options.baseUrl+path);
//     Response res = await dio.get(path, queryParameters: query,);
//
//
//     return handleResponse(res);
//   }
//
//   static Future<Map<String, dynamic>> setData(
//       {
//         required String path,
//         Map<String, dynamic>? query,
//         required data,
//
//       }) async {
//
//       log(data.toString());
//       log(dio.options.baseUrl+path.toString());
//
//
//       return handleResponse(await dio.post(
//         path,
//         data:data,
//         queryParameters: query,
//       ));
//   }
//
//   static Future<Map<String, dynamic>> putData(
//       {
//         required String path,
//         Map<String, dynamic>? query,
//         required data,
//
//       }) async {
//
//     Response res = await dio.put(
//       path,
//       data:data,
//       queryParameters: query,
//     );
//
//
//     return handleResponse(res);
//   }
//
//   static Future<Map<String, dynamic>> patchData(
//       {
//         required String path,
//         Map<String, dynamic>? query,
//         required data,
//
//       }) async {
//
//     Response res = await dio.patch(
//       path,
//       data:data,
//       queryParameters: query,
//     );
//
//
//     return handleResponse(res);
//   }
//
//
//   static Future<Map<String, dynamic>> deleteData(
//       {
//         required String path,
//         Map<String, dynamic>? query,
//         data,
//
//       }) async {
//     Response res = await dio.delete(
//       path,
//       data:data,
//       queryParameters: query,
//     );
//     return handleResponse(res);
//   }
//
//  static dynamic handleResponse(Response response){
//    log('handle response');
//      log(response.statusCode.toString());
//      log(response.statusCode.toString()[0]);
//     if(response.statusCode.toString()[0] != "2"){
//       log('error from handle response ');
//       log(response.data.toString());
//       String message = responseErrorHelper.getErrorsMessageFromJson(response.data);
//       throw  ServerException(exceptionMessage: message);
//     }
//     return response.data ;
//   }
//
//
// }