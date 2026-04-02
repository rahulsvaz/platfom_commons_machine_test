import 'package:dartz/dartz.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movies_page.dart';

abstract class MovieRepo {
  Future<Either<Failure, MoviesPage>> getTrendingMovies({required int page});
  Future<Either<Failure, Movie>> getMovieDetails({
    required String movieId,
    Movie? fallbackMovie,
  });
  Future<Either<Failure, List<Movie>>> getBookmarkedMovies({
    required String userStorageId,
  });
  Future<Either<Failure, List<Movie>>> toggleBookmark({
    required String userStorageId,
    required Movie movie,
    required bool shouldBookmark,
  });
}
