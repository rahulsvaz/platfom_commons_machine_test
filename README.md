# Flutter Developer Assignment

This is my machine test submission.

The app has a user section and a movie section. Users come from ReqRes. Movies come from OMDb. A user can be created online or offline, and bookmarks are stored separately for each user.

## What is done

- paginated user list
- add user screen
- offline user creation with Hive
- movie list for the selected user
- movie details screen
- bookmark tab for each user
- Hive cache for movie pages and movie details
- reconnect handling and retry for GET requests
- background sync setup with Workmanager

## Main flow

The app opens on the users screen.

From there:

1. users are loaded from ReqRes with pagination
2. tapping a user opens that user's movie screen
3. movies can be bookmarked from the list or detail page
4. the bookmark tab only shows items saved for that user

There is also an add user button on the users page. If the phone is online, the user is posted to ReqRes. If the phone is offline, the user is saved in Hive and shown in the list right away.

## Offline behavior

Offline support was the main part I focused on.

If the device is offline:

- a new user can still be created
- that user is stored locally
- the same user can go to the movie page
- bookmarks can still be saved for that user
- cached movie data is used when available

Bookmarks are stored in Hive by user key, so they stay separated per user.

## Workmanager

Workmanager is wired for background sync.

Files:

- `lib/core/sync/workmanager_bootstrap.dart`
- `lib/core/sync/sync_service.dart`

What it does:

- registers a periodic task called `sync-offline-payloads`
- runs roughly every hour
- opens Hive inside the background task
- checks for offline-created users that are still pending
- sends them to ReqRes when possible
- updates the local user with the returned server id

The app also triggers sync when connectivity comes back while the app is open, so it is not relying only on the periodic background task.

Bookmark data stays local because the public APIs used here do not provide a real bookmark write endpoint. The important part for this assignment is that the user and bookmark relationship is preserved correctly.

## APIs used

### ReqRes

- `GET https://reqres.in/api/users?page={page}`
- `POST https://reqres.in/api/users`

### OMDb

- `GET https://www.omdbapi.com/?s=marvel&type=movie&page={page}&apikey=6a1edad5`
- `GET https://www.omdbapi.com/?i={imdbID}&plot=full&apikey=6a1edad5`

OMDb does not have a trending endpoint, so I used a paginated search query for the movie list.

## Tech used

- Flutter
- Bloc
- get_it
- Dio
- Hive
- Workmanager
- GoRouter
- CachedNetworkImage

## Project structure

```text
lib/
  core/
    api/
    error/
    navigation/
    network/
    storage/
    sync/
    theme/
  features/
    users/
      data/
      domain/
      presentation/
    movies/
      data/
      domain/
      presentation/
  shared/
    style/
    widgets/
    injection_container.dart
  app.dart
  main.dart
```

## Folder notes

### `lib/core`

Shared app infrastructure.

- `api` has API constants and Dio setup
- `error` has shared failure classes
- `navigation` has routes and router setup
- `network` has connectivity and simulated failure handling
- `storage` has Hive setup
- `sync` has sync logic and Workmanager bootstrap
- `theme` has app theme setup

### `lib/features/users`

Everything related to user fetching, user creation, pagination, and user state.

### `lib/features/movies`

Everything related to movie fetching, movie details, caching, bookmarks, and movie state.

### `lib/shared`

Shared UI files and dependency registration.

## Important files

If someone wants to read the project quickly, these are the files I would open first:

1. `lib/main.dart`
2. `lib/app.dart`
3. `lib/shared/injection_container.dart`
4. `lib/core/navigation/app_navigator.dart`
5. `lib/features/users/data/repository/user_repo_impl.dart`
6. `lib/features/users/presentation/bloc/user_bloc.dart`
7. `lib/features/movies/data/repository/movie_repo_impl.dart`
8. `lib/features/movies/presentation/bloc/movie_bloc.dart`
9. `lib/core/sync/sync_service.dart`

## Local storage

Hive boxes used in the app:

- `users_box`
- `user_pages_box`
- `movie_pages_box`
- `movie_details_box`
- `bookmarks_box`

`bookmarks_box` stores bookmark lists per user key, not as one global list.

## Run

```bash
flutter pub get
flutter run
```

For release build:

```bash
flutter build apk --release
```

For analyzer:

```bash
flutter analyze
```

## Notes

- The movie side is using OMDb because it was the more reliable option during device testing.
- Some assignment wording mentions TMDb trending movies, but OMDb was allowed as an alternative.
- I removed older unused files from the project so only the app-related files remain.
