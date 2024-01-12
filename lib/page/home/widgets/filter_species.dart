import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/page/home/cubit/home_cubit.dart';

class FilterSpecies extends StatefulWidget {
  const FilterSpecies({
    super.key,
  });

  @override
  State<FilterSpecies> createState() => _FilterSpeciesState();
}

class _FilterSpeciesState extends State<FilterSpecies> {
  static const species = <String>[
    'All',
    'Human',
    'Alien',
    'Humanoid',
    'Poopybutthole',
    'Mythological Creature',
  ];
  String dropdownValue = species.first;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Species',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        DropdownButton(
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey[900],
          iconEnabledColor: Colors.white,
          underline: Container(
            height: 1,
            color: Colors.white,
          ),
          value: dropdownValue,
          items: species
              .map<DropdownMenuItem<String>>(
                  (species) => DropdownMenuItem<String>(
                        value: species,
                        child: Text(species),
                      ))
              .toList(),
          onChanged: (String? value) {
            if (value != null) {
              if (value == "All") {
                context.read<HomeCubit>().emitHomeInitial();
                context.read<HomeCubit>().fetchPage();
              } else {
                context.read<HomeCubit>().fetchBySpecies(value);
              }
              setState(() {
                dropdownValue = value;
              });
            }
          },
        )
      ],
    );
  }
}
