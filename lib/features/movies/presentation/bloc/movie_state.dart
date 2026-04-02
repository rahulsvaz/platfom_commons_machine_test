part of 'movie_bloc.dart';

enum MovieStatus { initial, loading, success, error }

class MovieState extends Equatable {
  final MovieStatus status;
  final User? selectedUser;
  final List<Movie> movies;
  final List<Movie> bookmarkedMovies;
  final Movie? selectedMovie;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isLoadingDetails;
  final String? errorMessage;

  const MovieState({
    this.status = MovieStatus.initial,
    this.selectedUser,
    this.movies = const [],
    this.bookmarkedMovies = const [],
    this.selectedMovie,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isLoadingDetails = false,
    this.errorMessage,
  });

  MovieState copyWith({
    MovieStatus? status,
    User? selectedUser,
    List<Movie>? movies,
    List<Movie>? bookmarkedMovies,
    Movie? selectedMovie,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isLoadingDetails,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MovieState(
      status: status ?? this.status,
      selectedUser: selectedUser ?? this.selectedUser,
      movies: movies ?? this.movies,
      bookmarkedMovies: bookmarkedMovies ?? this.bookmarkedMovies,
      selectedMovie: selectedMovie ?? this.selectedMovie,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedUser,
    movies,
    bookmarkedMovies,
    selectedMovie,
    currentPage,
    hasMore,
    isLoadingMore,
    isLoadingDetails,
    errorMessage,
  ];
}
