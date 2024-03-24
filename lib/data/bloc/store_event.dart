part of 'store_bloc.dart';

@immutable
abstract class StoreEvent extends Equatable {}


class StoreEventCategory extends StoreEvent {
  String accessToken;
  StoreEventCategory(this.accessToken);

  @override
  List<Object> get props => [accessToken];
}

class CreateStoreEventCategory extends StoreEvent {
  String accessToken;
  StoreRegistrationModel storeRegistrationModel;
  CreateStoreEventCategory(this.accessToken, this.storeRegistrationModel);

  @override
  List<Object> get props => [accessToken, storeRegistrationModel];
}