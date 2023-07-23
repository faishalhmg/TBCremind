part of 'pasien_bloc.dart';

abstract class PasienState extends Equatable {}

class PasienLoadingState extends PasienState {
  @override
  List<Object?> get props => [];
}

class PasienErrorState extends PasienState {
  final String error;
  PasienErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class UserPasienState extends PasienState {
  List userModel = [];
  UserPasienState(this.userModel);
  @override
  List<Object?> get props => [userModel];
}

class LoadPasienState extends PasienState {
  final UserModel userModel;
  LoadPasienState(this.userModel);
  @override
  List<Object?> get props => [userModel];
}

class SearchPasienState extends PasienState {
  final List<dynamic> searchResult;

  SearchPasienState(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}
