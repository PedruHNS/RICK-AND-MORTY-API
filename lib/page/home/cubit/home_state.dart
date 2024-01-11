part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  final List<PersonModel> characters;
  final bool hasReachedMax;
  final int page;

  const HomeState({
    this.characters = const [],
    this.hasReachedMax = false,
    this.page = 1,
  });

  @override
  List<Object> get props => [
        characters,
        hasReachedMax,
      ];
}

final class HomeInitial extends HomeState {}

final class HomeSuccess extends HomeState {
  const HomeSuccess(
      {required super.characters,
      required super.hasReachedMax,
      required super.page});
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
