part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoviesEvent extends MovieEvent {
  final User user;

  const LoadMoviesEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoadMoreMoviesEvent extends MovieEvent {
  const LoadMoreMoviesEvent();
}

class LoadMovieDetailsEvent extends MovieEvent {
  final String movieId;
  final Movie? fallbackMovie;

  const LoadMovieDetailsEvent({required this.movieId, this.fallbackMovie});

  @override
  List<Object?> get props => [movieId, fallbackMovie];
}

class ToggleMovieBookmarkEvent extends MovieEvent {
  final User user;
  final Movie movie;
  final bool shouldBookmark;

  const ToggleMovieBookmarkEvent({
    required this.user,
    required this.movie,
    required this.shouldBookmark,
  });

  @override
  List<Object?> get props => [user, movie, shouldBookmark];
}
