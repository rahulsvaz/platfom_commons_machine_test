import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';

class MoviesPage {
  final List<Movie> movies;
  final int currentPage;
  final int totalPages;

  const MoviesPage({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
  });

  bool get hasMore => currentPage < totalPages;
}
