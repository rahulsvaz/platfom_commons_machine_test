import 'package:get_it/get_it.dart';
import 'package:platfom_commons_machine_test/core/api/dio_api_client.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_cubit.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_service.dart';
import 'package:platfom_commons_machine_test/core/storage/hive_storage_service.dart';
import 'package:platfom_commons_machine_test/core/sync/sync_service.dart';
import 'package:platfom_commons_machine_test/features/movies/data/datasource/movie_remote_data_source.dart';
import 'package:platfom_commons_machine_test/features/movies/data/repository/movie_repo_impl.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/repository/movie_repo.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:platfom_commons_machine_test/features/users/data/datasource/user_remote_data_source.dart';
import 'package:platfom_commons_machine_test/features/users/data/repository/user_repo_impl.dart';
import 'package:platfom_commons_machine_test/features/users/domain/repository/user_repo.dart';
import 'package:platfom_commons_machine_test/features/users/domain/usecases/use_cases.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _registerCore();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

Future<void> _registerCore() async {
  sl.registerLazySingleton<DioApiClient>(() => DioApiClient());
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  final storage = HiveStorageService();
  await storage.init();
  sl.registerLazySingleton<HiveStorageService>(() => storage);
  sl.registerLazySingleton<SyncService>(
    () => SyncService(sl<HiveStorageService>(), sl<UserRemoteDataSource>()),
  );
}

void _registerDataSources() {
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl<DioApiClient>()),
  );
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSource(sl<DioApiClient>()),
  );
}

void _registerRepositories() {
  sl.registerLazySingleton<UserRepo>(
    () => UserRepoImpl(sl<UserRemoteDataSource>(), sl<HiveStorageService>()),
  );
  sl.registerLazySingleton<MovieRepo>(
    () => MovieRepoImpl(
      sl<MovieRemoteDataSource>(),
      sl<HiveStorageService>(),
      sl<ConnectivityService>(),
    ),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton(() => GetUsersPage(sl<UserRepo>()));
  sl.registerLazySingleton(() => GetCreatedUsers(sl<UserRepo>()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl<UserRepo>()));
  sl.registerLazySingleton(() => SyncPendingUsers(sl<UserRepo>()));

  sl.registerLazySingleton(() => GetTrendingMovies(sl<MovieRepo>()));
  sl.registerLazySingleton(() => GetMovieDetails(sl<MovieRepo>()));
  sl.registerLazySingleton(() => GetBookmarkedMovies(sl<MovieRepo>()));
  sl.registerLazySingleton(() => ToggleBookmark(sl<MovieRepo>()));
}

void _registerBlocs() {
  sl.registerFactory(() => ConnectivityCubit(sl<ConnectivityService>()));
  sl.registerFactory(
    () => UserBloc(
      getUsersPage: sl<GetUsersPage>(),
      getCreatedUsers: sl<GetCreatedUsers>(),
      createUser: sl<CreateUserUseCase>(),
      syncPendingUsers: sl<SyncPendingUsers>(),
    ),
  );
  sl.registerFactory(
    () => MovieBloc(
      getTrendingMovies: sl<GetTrendingMovies>(),
      getMovieDetails: sl<GetMovieDetails>(),
      getBookmarkedMovies: sl<GetBookmarkedMovies>(),
      toggleBookmark: sl<ToggleBookmark>(),
    ),
  );
}
