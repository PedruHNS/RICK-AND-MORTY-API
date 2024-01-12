import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/model/person_model.dart';
import 'package:rick_morty/page/character/character_page.dart';
import 'package:rick_morty/page/home/cubit/home_cubit.dart';
import 'package:rick_morty/page/home/home_page.dart';
import 'package:rick_morty/repository/rick_and_morty_repository.dart';
import 'package:rick_morty/service/rest_client/rest_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => HomeCubit(
                        RickAndMortyRepository(client: RestClientDio())),
                    child: const HomePage(),
                  ));
        }
        if (settings.name == '/character') {
          final person = settings.arguments as PersonModel;
          return MaterialPageRoute(
            builder: (context) => CharacterPage(
              person: person,
            ),
          );
        }
        return null;
      },
    );
  }
}
