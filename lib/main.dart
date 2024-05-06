import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const appHeader = 'Home page';
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appHeader,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const HomePage(),
      ),
    ),
  );
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({required bool isFavorite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() => 'Film: id: $id, '
      'title: $title, '
      'description: $description, '
      'isFavorite: $isFavorite ;';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll(
        [
          id,
          isFavorite,
        ],
      );
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appHeader,
        ),
      ),
    );
  }
}

const allFilms = [
  Film(
    id: '1',
    title: 'title1',
    description: 'descr1',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'title2',
    description: 'descr2',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'title3',
    description: 'descr3',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'title4',
    description: 'descr4',
    isFavorite: false,
  ),
];
