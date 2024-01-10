import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/page/home/cubit/home_cubit.dart';
import 'package:rick_morty/page/home/widgets/filter_species.dart';
import 'package:rick_morty/page/home/widgets/list_view_person.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _TextController = TextEditingController();

  void _onScroll() {
    if (_isBottom(context.read<HomeCubit>().state)) {
      context.read<HomeCubit>().fetchPage();
    }
  }

  bool _isBottom(HomeState state) {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9 && state is! HomeLoading;
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    context.read<HomeCubit>().fetchPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {},
                    controller: _TextController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const FilterSpecies(),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2),
                    )
                  ]),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return switch (state) {
                    HomeInitial() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    HomeLoading() => ListViewPerson(
                        characters: state.characters,
                        scrollController: _scrollController),
                    HomeSuccess() => ListViewPerson(
                        characters: state.characters,
                        scrollController: _scrollController),
                    HomeError() => const Center(
                        child: Text('error ao carregar'),
                      ),
                  };
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
