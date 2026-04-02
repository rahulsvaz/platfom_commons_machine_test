import 'package:platfom_commons_machine_test/features/movies/data/model/movie_model.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movies_page.dart';

class PaginatedMoviesModel {
  final int page;
  final int totalPages;
  final List<MovieModel> results;

  const PaginatedMoviesModel({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  factory PaginatedMoviesModel.fromJson(Map<String, dynamic> json) {
    final totalResults =
        int.tryParse(json['totalResults'] as String? ?? '') ?? 0;

    return PaginatedMoviesModel(
      page: json['page'] as int? ?? 1,
      totalPages: totalResults <= 0 ? 1 : (totalResults / 10).ceil(),
      results: (json['Search'] as List<dynamic>? ?? [])
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  factory PaginatedMoviesModel.fromMap(Map<String, dynamic> map) {
    return PaginatedMoviesModel(
      page: map['page'] as int? ?? 1,
      totalPages: map['totalPages'] as int? ?? 1,
      results: (map['results'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                MovieModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'totalPages': totalPages,
      'results': results.map((movie) => movie.toMap()).toList(growable: false),
    };
  }

  MoviesPage toEntity() {
    return MoviesPage(
      movies: results.map((movie) => movie.toEntity()).toList(growable: false),
      currentPage: page,
      totalPages: totalPages,
    );
  }
}
