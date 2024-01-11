import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:rick_morty/model/person_model.dart';
import 'package:rick_morty/repository/rick_and_morty_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final RickAndMortyRepository repository;

  HomeCubit(this.repository) : super(HomeInitial());

  Future<void> fetchPage() async {
    final currentState = state;

    final newCharacters =
        await repository.findAllPerson(page: currentState.page);

    List<PersonModel> currentCharacters = [];
    if (currentState is HomeSuccess) {
      currentCharacters = currentState.characters;
    } else {
      currentCharacters = [];
    }

    emit(HomeSuccess(
        characters: [...currentCharacters, ...newCharacters],
        hasReachedMax: false,
        page: currentState.page + 1));
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
        characters: [...currentCharacters, ...newCharacters],
        hasReachedMax: false,
        page: pageNext));
    
  }
}
