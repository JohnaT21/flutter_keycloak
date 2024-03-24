import 'package:dartz/dartz.dart';
import 'package:keycloakdemo/data/Model/StoreModel.dart';
import 'package:keycloakdemo/data/Model/store_registration.dart';
import 'package:keycloakdemo/data/Model/store_registration_response.dart';
import 'package:keycloakdemo/data/service/store_service.dart';

import '../Model/StoreReturn.dart';

abstract class StoreRepository{
  Future<Either<StoreModel,StoreReturn>> storeCategory(String accessToken);
  Future<Either<StoreModel,StoreRegistrationResponse>> createStore(String accessToken, StoreRegistrationModel storeRegistrationModel);
}

class StoreRepositoryImpl extends StoreRepository {
  final StoreService storeService;

  StoreRepositoryImpl({required this.storeService});


  @override
  Future<Either<StoreModel, StoreReturn>> storeCategory(String accessToken) async {
    var response = await storeService.LottoryCatagory(accessToken);
    return response.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<StoreModel, StoreRegistrationResponse>> createStore(String accessToken, StoreRegistrationModel storeRegistrationModel) async{
    var response = await storeService.storeCreate(accessToken, storeRegistrationModel);
    return response.fold((l) => Left(l), (r) => Right(r));
  }

}