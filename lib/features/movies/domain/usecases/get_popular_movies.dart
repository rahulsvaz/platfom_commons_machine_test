import 'package:dartz/dartz.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movies_page.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/repository/movie_repo.dart';

class GetTrendingMovies {
  final MovieRepo _movieRepo;

  const GetTrendingMovies(this._movieRepo);

  Future<Either<Failure, MoviesPage>> call({required int page}) {
    return _movieRepo.getTrendingMovies(page: page);
  }
}

class GetMovieDetails {
  final MovieRepo _movieRepo;

  const GetMovieDetails(this._movieRepo);

  Future<Either<Failure, Movie>> call({
    required String movieId,
    Movie? fallbackMovie,
  }) {
    return _movieRepo.getMovieDetails(
      movieId: movieId,
      fallbackMovie: fallbackMovie,
    );
  }
}

class GetBookmarkedMovies {
  final MovieRepo _movieRepo;

  const GetBookmarkedMovies(this._movieRepo);

  Future<Either<Failure, List<Movie>>> call({required String userStorageId}) {
    return _movieRepo.getBookmarkedMovies(userStorageId: userStorageId);
  }
}

class ToggleBookmark {
  final MovieRepo _movieRepo;

  const ToggleBookmark(this._movieRepo);

  Future<Either<Failure, List<Movie>>> call({
    required String userStorageId,
    required Movie movie,
    required bool shouldBookmark,
  }) {
    return _movieRepo.toggleBookmark(
      userStorageId: userStorageId,
      movie: movie,
      shouldBookmark: shouldBookmark,
    );
  }
}
