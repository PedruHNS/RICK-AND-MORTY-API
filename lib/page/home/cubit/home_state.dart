part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  final List<PersonModel> characters;
  final bool hasReachedMax;
  final String filter;
  final int page;

  const HomeState({
    this.characters = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.filter = 'All',
  });

  @override
  List<Object> get props => [
        characters,
        hasReachedMax,
        page,
        filter,
      ];
}

final class HomeInitial extends HomeState {}

final class HomeSuccess extends HomeState {
  const HomeSuccess({
    required super.characters,
    required super.hasReachedMax,
    required super.page,
    required super.filter,
  });
}

final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
