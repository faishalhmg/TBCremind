part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class UserSignedOut extends UserState {
  @override
  List<Object?> get props => [];
}

class UserSignedIn extends UserState {
  final UserModel userModel;
  UserSignedIn({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class UserLoadedState extends UserState {
  final UserModel userModel;
  UserLoadedState(this.userModel);
  @override
  List<Object?> get props => [userModel];
}
