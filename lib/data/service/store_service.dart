
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:keycloakdemo/data/Model/store_registration.dart';
import 'package:keycloakdemo/util/constant.dart';
import 'package:keycloakdemo/data/Model/StoreModel.dart';
import 'package:keycloakdemo/data/Model/StoreReturn.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../Model/store_registration_response.dart';

class StoreService{
  Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 50000000000),
    receiveTimeout: Duration(seconds: 500000000000),
    headers: {
      'Authorization': 'No Auth',
      "Content-Type": "application/json",
    },
  ));

  Future<Either<StoreModel,StoreReturn>> LottoryCatagory(String accessToken) async{

  var logger = Logger();
  logger.d("from the service: ${AppConstant.API_BASE_URL}/allStore");
    Response? response;
  dio.options.headers['Authorization'] = 'Bearer $accessToken';


  try{
      response = await dio.get("${AppConstant.API_BASE_URL}/allStore");


      print("from lottory service");
      print(response.statusCode );
      // Map<String, dynamic> jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      return Right(StoreReturn.fromJson(response.data));
    }catch(e){
      if (e is DioError) {
        return Left(StoreModel(message: "error occured"));
      } else {
        throw Exception(e);
      }
    }
  }


  Future<Either<StoreModel,StoreRegistrationResponse>> storeCreate(String accessToken, StoreRegistrationModel storeRegistrationModel) async{

    var logger = Logger();
    logger.d("from the service of create: $accessToken");
    Response? response;
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
  logger.d("the created store");
    logger.d(storeRegistrationModel.toJson());

    try{
      response = await dio.post("${AppConstant.API_BASE_URL}/createStore",
      data: storeRegistrationModel.toJson());


      print("from create service");
      print(response.statusCode );
      // Map<String, dynamic> jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      return Right(StoreRegistrationResponse.fromJson(response.data));
    }catch(e){
      logger.d("error from creatin: $e");

      if (e is DioError) {
        return Left(StoreModel(message: "error occured"));
      } else {
        throw Exception(e);
      }
    }
  }

}