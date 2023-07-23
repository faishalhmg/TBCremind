part of 'pasien_bloc.dart';

abstract class PasienEvent extends Equatable {
  const PasienEvent();

  @override
  List<Object> get props => [];
}

class LoadPasienEvent extends PasienEvent {
  const LoadPasienEvent();
  @override
  List<Object> get props => [];
}

class LoadedPasienEvent extends PasienEvent {
  final String nikOremail;

  const LoadedPasienEvent({required this.nikOremail});

  @override
  List<Object> get props => [nikOremail];
}

class SearchPasienEvent extends PasienEvent {
  final String query;

  const SearchPasienEvent(this.query);

  @override
  List<Object> get props => [query];
}
