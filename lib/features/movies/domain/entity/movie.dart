class Movie {
  final String id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final double rating;
  final double popularity;
  final String originalLanguage;
  final bool isBookmarked;
  final bool isSynced;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.releaseDate,
    required this.rating,
    required this.popularity,
    required this.originalLanguage,
    this.isBookmarked = false,
    this.isSynced = true,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    String? releaseDate,
    double? rating,
    double? popularity,
    String? originalLanguage,
    bool? isBookmarked,
    bool? isSynced,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      rating: rating ?? this.rating,
      popularity: popularity ?? this.popularity,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
