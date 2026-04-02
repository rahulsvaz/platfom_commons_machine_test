import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/pages/movie_details_page.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/pages/movies_listing_page.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/bloc/user_bloc.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/pages/add_user_page.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/pages/users_listing_page.dart';
import 'package:platfom_commons_machine_test/shared/injection_container.dart';

import 'app_routes.dart';

final class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.users,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.users,
        name: AppRoutes.users,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<UserBloc>()
            ..add(const LoadUsersEvent())
            ..add(const SyncUsersEvent()),
          child: const UsersListingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addUser,
        name: AppRoutes.addUser,
        builder: (context, state) => BlocProvider.value(
          value: state.extra! as UserBloc,
          child: const AddUserPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.movies,
        name: AppRoutes.movies,
        builder: (context, state) {
          final user = state.extra! as User;
          return BlocProvider(
            create: (_) => sl<MovieBloc>()..add(LoadMoviesEvent(user: user)),
            child: MoviesListingPage(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.movieDetails,
        name: AppRoutes.movieDetails,
        builder: (context, state) {
          final payload = state.extra! as Map<String, dynamic>;
          return BlocProvider.value(
            value: payload['bloc'] as MovieBloc,
            child: MovieDetailsPage(
              user: payload['user'] as User,
              movie: payload['movie'] as Movie,
            ),
          );
        },
      ),
    ],
  );
}
