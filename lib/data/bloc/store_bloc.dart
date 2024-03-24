import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keycloakdemo/data/Model/store_registration_response.dart';
import 'package:keycloakdemo/data/Repository/store_repository.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../Model/StoreReturn.dart';
import '../Model/store_registration.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
 final StoreRepository storeRepository;
  StoreBloc(this.storeRepository) : super(StoreInitial()) {
    on<StoreEvent>((event, emit) async {
      if(event is StoreEventCategory) {
        var logger = Logger();
        logger.d("the event called");
        emit(LoadingStoreState());
        logger.d("the event called loading");

        var storeData = await storeRepository.storeCategory(event.accessToken);
        logger.d("the event storeData");
        storeData.fold((error) {
          emit(ErrorGettingStoreState());
          logger.d("the event called errorr emitted");
        },
                (right) =>
                emit(LoadedStoreState(storeReturn: right)));
      }

      if(event is CreateStoreEventCategory) {
        var logger = Logger();
        logger.d("the event called");
        emit(LoadingStoreState());
        logger.d("the event called loading");

        var storeData = await storeRepository.createStore(event.accessToken, event.storeRegistrationModel);
        logger.d("the event storeData");
        storeData.fold((error) {
          emit(ErrorGettingStoreState());
          logger.d("the event called errorr emitted");
        },
                (right) =>
                emit(LoadedStoreCreateState(storeRegistrationResponse: right)));
      }

  });
}
}
