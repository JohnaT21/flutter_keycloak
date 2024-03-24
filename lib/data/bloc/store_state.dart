part of 'store_bloc.dart';

@immutable
abstract class StoreState extends Equatable {}

class StoreInitial extends StoreState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class LoadingStoreState extends StoreState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}


class ErrorGettingStoreState extends StoreState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
  // final ErrorLogin errorResponse;
  // const ErrorGettingLottryC(this.errorResponse);
  //
  // @override
  // List<Object> get props => [errorResponse];
}

class LoadedStoreState extends StoreState {
  final StoreReturn storeReturn;

  LoadedStoreState({required this.storeReturn});
  var logger = Logger();

  @override
  // TODO: implement props
  List<Object?> get props => [];

  // @override
  // List<Object> get props => [storeReturn];

}

class LoadedStoreCreateState extends StoreState {
  final StoreRegistrationResponse storeRegistrationResponse;

  LoadedStoreCreateState({required this.storeRegistrationResponse});
  var logger = Logger();

  @override
  // TODO: implement props
  List<Object?> get props => [];

// @override
// List<Object> get props => [storeReturn];

}
