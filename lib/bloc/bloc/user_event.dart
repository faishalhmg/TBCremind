part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends UserEvent {
  final String nikOremail;
  final String password;

  const SignIn({required this.nikOremail, required this.password});

  @override
  List<Object> get props => [nikOremail, password];
}

class SignOut extends UserEvent {}

class CheckSignInStatus extends UserEvent {}

class UpdateProfile extends UserEvent {
  final UserModel userModel;
  final int id;
  const UpdateProfile({required this.id, required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class loadProfile extends UserEvent {
  final String nikOremail;
  final String token;
  const loadProfile({required this.nikOremail, required this.token});

  @override
  List<Object> get props => [nikOremail, token];
}
