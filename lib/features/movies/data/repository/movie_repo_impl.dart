import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:platfom_commons_machine_test/core/error/failures.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_service.dart';
import 'package:platfom_commons_machine_test/core/storage/app_boxes.dart';
import 'package:platfom_commons_machine_test/core/storage/hive_storage_service.dart';
import 'package:platfom_commons_machine_test/features/movies/data/datasource/movie_remote_data_source.dart';
import 'package:platfom_commons_machine_test/features/movies/data/model/movie_model.dart';
import 'package:platfom_commons_machine_test/features/movies/data/model/paginated_movies_model.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movies_page.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/repository/movie_repo.dart';

class MovieRepoImpl implements MovieRepo {
  final MovieRemoteDataSource _remoteDataSource;
  final HiveStorageService _storage;
  final ConnectivityService _connectivityService;

  const MovieRepoImpl(
    this._remoteDataSource,
    this._storage,
    this._connectivityService,
  );

  String _bookmarkStorageKey(String userStorageId) => 'user_$userStorageId';

  @override
  Future<Either<Failure, MoviesPage>> getTrendingMovies({
    required int page,
  }) async {
    final pageBox = _storage.box(AppBoxes.moviePages);

    try {
      final remotePage = await _remoteDataSource.getTrendingMovies(page: page);
      await pageBox.put('page_$page', remotePage.toMap());
      return Right(remotePage.toEntity());
    } on DioException catch (e) {
      final cached = pageBox.get('page_$page');
      if (cached is Map) {
        return Right(
          PaginatedMoviesModel.fromMap(
            Map<String, dynamic>.from(cached),
          ).toEntity(),
        );
      }
      return Left(
        ServerFailure(
          message:
              e.response?.data?['status_message'] as String? ??
              e.message ??
              'Unable to load movies.',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails({
    required String movieId,
    Movie? fallbackMovie,
  }) async {
    final detailsBox = _storage.box(AppBoxes.movieDetails);

    try {
      final details = await _remoteDataSource.getMovieDetails(movieId: movieId);
      await detailsBox.put(movieId, details.toMap());
      return Right(details.toEntity());
    } on DioException catch (e) {
      final cached = detailsBox.get(movieId);
      if (cached is Map) {
        return Right(
          MovieModel.fromMap(Map<String, dynamic>.from(cached)).toEntity(),
        );
      }
      if (fallbackMovie != null) {
        return Right(fallbackMovie);
      }
      return Left(
        ServerFailure(
          message:
              e.response?.data?['status_message'] as String? ??
              e.message ??
              'Unable to load movie details.',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getBookmarkedMovies({
    required String userStorageId,
  }) async {
    try {
      final bookmarksBox = _storage.box(AppBoxes.bookmarks);
      final bookmarkKey = _bookmarkStorageKey(userStorageId);
      final storedItems =
          (bookmarksBox.get(bookmarkKey) ??
                  bookmarksBox.get(userStorageId) ??
                  <dynamic>[])
              as List<dynamic>;
      if (bookmarksBox.containsKey(userStorageId) &&
          !bookmarksBox.containsKey(bookmarkKey)) {
        await bookmarksBox.put(bookmarkKey, storedItems);
        await bookmarksBox.delete(userStorageId);
      }
      final items = storedItems
          .map(
            (item) =>
                MovieModel.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .map((movie) => movie.toEntity())
          .toList(growable: false);
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> toggleBookmark({
    required String userStorageId,
    required Movie movie,
    required bool shouldBookmark,
  }) async {
    try {
      final bookmarksBox = _storage.box(AppBoxes.bookmarks);
      final bookmarkKey = _bookmarkStorageKey(userStorageId);
      final isOnline = await _connectivityService.hasInternetConnection();
      final current =
          ((bookmarksBox.get(bookmarkKey) ?? bookmarksBox.get(userStorageId))
                      as List<dynamic>? ??
                  [])
              .map(
                (item) =>
                    MovieModel.fromMap(Map<String, dynamic>.from(item as Map)),
              )
              .toList();

      if (shouldBookmark) {
        final exists = current.any((item) => item.id == movie.id);
        if (!exists) {
          current.add(
            MovieModel.fromEntity(
              movie.copyWith(isBookmarked: true, isSynced: isOnline),
            ),
          );
        }
      } else {
        current.removeWhere((item) => item.id == movie.id);
      }

      await bookmarksBox.put(
        bookmarkKey,
        current.map((movie) => movie.toMap()).toList(growable: false),
      );
      if (bookmarksBox.containsKey(userStorageId) &&
          bookmarkKey != userStorageId) {
        await bookmarksBox.delete(userStorageId);
      }

      return Right(
        current.map((movie) => movie.toEntity()).toList(growable: false),
      );
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
