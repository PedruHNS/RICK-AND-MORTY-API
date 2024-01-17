import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/model/person_model.dart';
import 'package:rick_morty/page/home/cubit/home_cubit.dart';
import 'package:rick_morty/page/home/widgets/bottom_loader.dart';
import 'package:rick_morty/page/home/widgets/card_character.dart';

class ListViewPerson extends StatelessWidget {
  final ScrollController scrollController;
  final List<PersonModel> characters;
  const ListViewPerson(
      {super.key, required this.scrollController, required this.characters});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: context.read<HomeCubit>().state.hasReachedMax
            ? characters.length
            : characters.length + 1,
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index >= characters.length) {
            return context.read<HomeCubit>().state.hasReachedMax
                ? const SizedBox()
                : const BottomLoader();
          }
          return CardCharacter(person: characters[index]);
        });
  }
}
