import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTrendingMovies _getTrendingMovies;
  final GetMovieDetails _getMovieDetails;
  final GetBookmarkedMovies _getBookmarkedMovies;
  final ToggleBookmark _toggleBookmark;

  MovieBloc({
    required GetTrendingMovies getTrendingMovies,
    required GetMovieDetails getMovieDetails,
    required GetBookmarkedMovies getBookmarkedMovies,
    required ToggleBookmark toggleBookmark,
  }) : _getTrendingMovies = getTrendingMovies,
       _getMovieDetails = getMovieDetails,
       _getBookmarkedMovies = getBookmarkedMovies,
       _toggleBookmark = toggleBookmark,
       super(const MovieState()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<ToggleMovieBookmarkEvent>(_onToggleMovieBookmark);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MovieStatus.loading,
        selectedUser: event.user,
        clearError: true,
      ),
    );

    final bookmarksResult = await _getBookmarkedMovies(
      userStorageId: event.user.storageId,
    );
    final pageResult = await _getTrendingMovies(page: 1);

    final bookmarks = bookmarksResult.fold((_) => <Movie>[], (items) => items);
    final bookmarkIds = bookmarks.map((movie) => movie.id).toSet();

    pageResult.fold(
      (failure) => emit(
        state.copyWith(
          status: MovieStatus.error,
          selectedUser: event.user,
          bookmarkedMovies: bookmarks,
          errorMessage: failure.message,
          currentPage: 1,
          hasMore: false,
        ),
      ),
      (page) {
        final decoratedMovies = page.movies
            .map(
              (movie) =>
                  movie.copyWith(isBookmarked: bookmarkIds.contains(movie.id)),
            )
            .toList(growable: false);

        emit(
          state.copyWith(
            status: MovieStatus.success,
            selectedUser: event.user,
            movies: decoratedMovies,
            bookmarkedMovies: bookmarks,
            currentPage: page.currentPage,
            hasMore: page.hasMore,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.selectedUser == null) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearError: true));
    final nextPage = state.currentPage + 1;
    final result = await _getTrendingMovies(page: nextPage);
    final bookmarkIds = state.bookmarkedMovies.map((movie) => movie.id).toSet();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (page) {
        final decoratedMovies = page.movies
            .map(
              (movie) =>
                  movie.copyWith(isBookmarked: bookmarkIds.contains(movie.id)),
            )
            .toList(growable: false);

        emit(
          state.copyWith(
            status: MovieStatus.success,
            movies: [...state.movies, ...decoratedMovies],
            currentPage: page.currentPage,
            hasMore: page.hasMore,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetails: true, clearError: true));
    final result = await _getMovieDetails(
      movieId: event.movieId,
      fallbackMovie: event.fallbackMovie,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingDetails: false, errorMessage: failure.message),
      ),
      (movie) => emit(
        state.copyWith(
          isLoadingDetails: false,
          selectedMovie: movie.copyWith(
            isBookmarked: state.bookmarkedMovies.any(
              (item) => item.id == movie.id,
            ),
          ),
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onToggleMovieBookmark(
    ToggleMovieBookmarkEvent event,
    Emitter<MovieState> emit,
  ) async {
    final result = await _toggleBookmark(
      userStorageId: event.user.storageId,
      movie: event.movie,
      shouldBookmark: event.shouldBookmark,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (bookmarks) {
        final bookmarkIds = bookmarks.map((movie) => movie.id).toSet();
        final updatedMovies = state.movies
            .map(
              (movie) =>
                  movie.copyWith(isBookmarked: bookmarkIds.contains(movie.id)),
            )
            .toList(growable: false);

        emit(
          state.copyWith(
            movies: updatedMovies,
            bookmarkedMovies: bookmarks,
            selectedMovie: state.selectedMovie?.copyWith(
              isBookmarked: bookmarkIds.contains(state.selectedMovie?.id),
            ),
            clearError: true,
          ),
        );
      },
    );
  }
}
