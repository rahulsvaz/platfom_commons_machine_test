import 'package:dio/dio.dart';
import 'package:platfom_commons_machine_test/core/api/api_support.dart';
import 'package:platfom_commons_machine_test/core/api/dio_api_client.dart';
import 'package:platfom_commons_machine_test/features/movies/data/model/movie_model.dart';
import 'package:platfom_commons_machine_test/features/movies/data/model/paginated_movies_model.dart';

class MovieRemoteDataSource {
  final DioApiClient _dio;

  const MovieRemoteDataSource(this._dio);

  Future<PaginatedMoviesModel> getTrendingMovies({required int page}) async {
    final response = await _dio.get(
      ApiSupport.movies(),
      apiName: 'GetTrendingMovies$page',
      useMovieApi: true,
      queryParameters: {
        's': ApiSupport.movieSearchQuery,
        'type': 'movie',
        'page': page,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);
    _throwIfMovieApiFailed(data, response.requestOptions);
    return PaginatedMoviesModel.fromJson({...data, 'page': page});
  }

  Future<MovieModel> getMovieDetails({required String movieId}) async {
    final response = await _dio.get(
      ApiSupport.movieDetails(movieId),
      apiName: 'GetMovieDetails$movieId',
      useMovieApi: true,
      queryParameters: {'i': movieId, 'plot': 'full'},
    );
    final data = Map<String, dynamic>.from(response.data as Map);
    _throwIfMovieApiFailed(data, response.requestOptions);
    return MovieModel.fromJson(data);
  }

  void _throwIfMovieApiFailed(
    Map<String, dynamic> data,
    RequestOptions requestOptions,
  ) {
    if ((data['Response'] as String?) == 'False') {
      throw DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          data: data,
        ),
        type: DioExceptionType.badResponse,
        message: data['Error'] as String? ?? 'Unable to load movies.',
      );
    }
  }
}
