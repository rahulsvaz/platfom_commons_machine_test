import 'package:platfom_commons_machine_test/core/api/api_support.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';

class MovieModel {
  final String id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double rating;
  final double popularity;
  final String originalLanguage;
  final bool isBookmarked;
  final bool isSynced;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.rating,
    required this.popularity,
    required this.originalLanguage,
    this.isBookmarked = false,
    this.isSynced = true,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String? ?? '';
    final released = json['Released'] as String? ?? '';
    final year = json['Year'] as String? ?? '';
    final language = json['Language'] as String? ?? 'N/A';
    final imdbRating =
        double.tryParse(json['imdbRating'] as String? ?? '') ?? 0;
    final plot = json['Plot'] as String? ?? '';
    final type = json['Type'] as String? ?? 'Movie';

    return MovieModel(
      id: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Untitled',
      overview: plot.isNotEmpty && plot != 'N/A'
          ? plot
          : '$type movie from ${year.isNotEmpty ? year : 'unknown year'}.',
      posterPath: poster == 'N/A' ? '' : poster,
      backdropPath: poster == 'N/A' ? '' : poster,
      releaseDate: released.isNotEmpty && released != 'N/A'
          ? released
          : (year.isNotEmpty ? year : 'Unknown'),
      rating: imdbRating,
      popularity: 0,
      originalLanguage: language == 'N/A' ? 'N/A' : language.toUpperCase(),
    );
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled',
      overview: map['overview'] as String? ?? '',
      posterPath: map['posterPath'] as String? ?? '',
      backdropPath: map['backdropPath'] as String? ?? '',
      releaseDate: map['releaseDate'] as String? ?? '',
      rating: (map['rating'] as num? ?? 0).toDouble(),
      popularity: (map['popularity'] as num? ?? 0).toDouble(),
      originalLanguage: map['originalLanguage'] as String? ?? 'N/A',
      isBookmarked: map['isBookmarked'] as bool? ?? false,
      isSynced: map['isSynced'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'rating': rating,
      'popularity': popularity,
      'originalLanguage': originalLanguage,
      'isBookmarked': isBookmarked,
      'isSynced': isSynced,
    };
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterUrl: ApiSupport.moviePoster(posterPath),
      backdropUrl: ApiSupport.moviePoster(backdropPath),
      releaseDate: releaseDate,
      rating: rating,
      popularity: popularity,
      originalLanguage: originalLanguage,
      isBookmarked: isBookmarked,
      isSynced: isSynced,
    );
  }

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterUrl,
      backdropPath: movie.backdropUrl,
      releaseDate: movie.releaseDate,
      rating: movie.rating,
      popularity: movie.popularity,
      originalLanguage: movie.originalLanguage,
      isBookmarked: movie.isBookmarked,
      isSynced: movie.isSynced,
    );
  }
}
