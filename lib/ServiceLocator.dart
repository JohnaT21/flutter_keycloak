
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:keycloakdemo/data/Repository/store_repository.dart';
import 'package:keycloakdemo/data/service/store_service.dart';

import 'data/bloc/store_bloc.dart';


final sl  = GetIt.instance;

Future initServiceLocator() async{

  /// Data providers
  ///

  sl.registerSingleton<Dio>(Dio());
  // sl.registerSingleton<ApiBaseHelper>(ApiBaseHelper());


  /// local storage => shared preference login token logout
  ///


  // var instance = await LocalStorageService.getInstance();
  // sl.registerSingleton<LocalStorageService>(instance);


  /// services

  sl.registerLazySingleton<StoreService>(() => StoreService());
  /// Repository

  sl.registerFactory<StoreRepository>(() => StoreRepositoryImpl(storeService: sl()));
/// Bloc

  sl.registerLazySingleton<StoreBloc>(() => StoreBloc(sl()));

}
