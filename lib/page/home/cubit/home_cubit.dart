import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:rick_morty/model/person_model.dart';
import 'package:rick_morty/repository/rick_and_morty_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RickAndMortyRepository repository;

  HomeCubit(this.repository) : super(HomeInitial());

  Future<void> fetchPage() async {
    if (state.hasReachedMax) return;
    final currentState = state;

    List<PersonModel> newCharacters = [];

    if (currentState.filter == 'All') {
      newCharacters = await repository.findAllPerson(page: currentState.page);
    } else {
      newCharacters = await repository.findAllBySpecies(
          page: currentState.page, species: currentState.filter);
    }

    List<PersonModel> currentCharacters =
        (currentState is HomeSuccess) ? currentState.characters : [];

    try {
      if (currentState.page >= 42) {
        emit(HomeSuccess(
          characters: [...currentCharacters, ...newCharacters],
          hasReachedMax: true,
          page: currentState.page,
          filter: currentState.filter,
        ));
      }
      final pageNext = currentState.page + 1;
      emit(HomeSuccess(
        characters: [...currentCharacters, ...newCharacters],
        hasReachedMax: false,
        page: pageNext,
        filter: currentState.filter,
      ));
    } on Exception catch (_) {
      emit(const HomeError('error'));
    }
  }

  Future<void> fetchBySpecies(String species) async {
    emit(HomeInitial());
    final currentState = state;

    final newCharacters = await repository.findAllBySpecies(
        page: currentState.page, species: species);

    List<PersonModel> currentCharacters =
        (currentState is HomeSuccess) ? currentState.characters : [];
    final pageNext = currentState.page + 1;

    emit(HomeSuccess(
      characters: [
        ...currentCharacters,
        ...newCharacters,
      ],
      hasReachedMax: false,
      page: pageNext,
      filter: species,
    ));
  }

  Future<void> findByname(String name) async {
    emit(HomeInitial());
    final currentState = state;
    final newCharacters = await repository.findByName(name: name);
    try {
      List<PersonModel> currentCharacters =
          (currentState is HomeSuccess) ? currentState.characters : [];
      emit(HomeSuccess(
        characters: [...currentCharacters, ...newCharacters],
        hasReachedMax: true,
        page: currentState.page,
        filter: currentState.filter,
      ));
    } on Exception catch (_) {
      emit(const HomeError('não encontrado'));
    }
  }

  void emitHomeInitial() {
    emit(HomeInitial());
  }
}
