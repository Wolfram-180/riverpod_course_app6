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

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void update(
    Film film,
    bool isFavorite,
  ) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.all,
);

// all films
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

// favorite films
final favoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavorite,
      ),
);

// not favorite films
final notFavoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavorite,
      ),
);

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
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(
            builder: (context, ref, child) {
              final filter = ref.watch(favoriteStatusProvider);
              switch (filter) {
                case FavoriteStatus.all:
                  return FilmsList(
                    provider: allFilmsProvider,
                  );
                case FavoriteStatus.favorite:
                  return FilmsList(
                    provider: favoriteFilmsProvider,
                  );
                case FavoriteStatus.notFavorite:
                  return FilmsList(
                    provider: notFavoriteFilmsProvider,
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favoriteIcon = film.isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border);
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: favoriteIcon,
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref.read(allFilmsProvider.notifier).update(
                      film,
                      isFavorite,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        context,
        ref,
        child,
      ) {
        return DropdownButton(
            value: ref.watch(
              favoriteStatusProvider,
            ),
            items: FavoriteStatus.values
                .map(
                  (fs) => DropdownMenuItem(
                    value: fs,
                    child: Text(
                      fs.toString().split('.').last,
                    ),
                  ),
                )
                .toList(),
            onChanged: (fs) {
              ref
                  .read(
                    favoriteStatusProvider.notifier,
                  )
                  .state = fs!;
            });
      },
    );
  }
}
