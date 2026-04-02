class ApiSupport {
  ApiSupport._();

  static const String reqresBaseUrl = 'https://reqres.in';
  static const String movieBaseUrl = 'https://www.omdbapi.com';

  static const String reqresApiKey = 'reqres_17fd2a6447ca48a88b74f1b692e6744c';
  static const String movieApiKey = '6a1edad5';
  static const String movieSearchQuery = 'marvel';
  static const bool enableFailureSimulation = false;

  static String users({int? page = 1}) => '/api/users?page=$page';
  static String movies() => '/';
  static String movieDetails(String movieId) => '/';
  static String moviePoster(String? path) =>
      path == null || path.isEmpty || path == 'N/A' ? '' : path;
}
