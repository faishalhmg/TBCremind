part of 'efek_bloc.dart';

@immutable
abstract class EfekState extends Equatable {}

//data loading state
class EfekLoadingState extends EfekState {
  @override
  List<Object?> get props => [];
}

class EfekLoadedState extends EfekState {
  List efek = [];
  EfekLoadedState(this.efek);
  @override
  List<Object?> get props => [efek];
}

class EfekErrorState extends EfekState {
  final String error;
  EfekErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class EfekAddState extends EfekState {
  List efek = [];
  EfekAddState(this.efek);
  @override
  List<Object?> get props => [efek];
}

class EfekUpdateState extends EfekState {
  List efek = [];

  EfekUpdateState(this.efek);
  @override
  List<Object?> get props => [efek];
}
