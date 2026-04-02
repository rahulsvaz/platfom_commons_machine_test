import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platfom_commons_machine_test/core/navigation/app_routes.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/widgets/movie_card.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';
import 'package:platfom_commons_machine_test/shared/widgets/animated_card_wrapper.dart';
import 'package:platfom_commons_machine_test/shared/widgets/app_back_button.dart';
import 'package:platfom_commons_machine_test/shared/widgets/bg_with_stack.dart';
import 'package:platfom_commons_machine_test/shared/widgets/network_status_chip.dart';

class MoviesListingPage extends StatefulWidget {
  final User user;

  const MoviesListingPage({super.key, required this.user});

  @override
  State<MoviesListingPage> createState() => _MoviesListingPageState();
}

class _MoviesListingPageState extends State<MoviesListingPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_selectedTabIndex == 1) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent * 0.75;
    if (_scrollController.position.pixels >= threshold) {
      context.read<MovieBloc>().add(const LoadMoreMoviesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Palette.redColor,
              content: Text(state.errorMessage!, style: Styles.poppins14White),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Palette.lightGrayBg,
          body: BackGroundWithStack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                AppBackButton(),
                                NetworkStatusChip(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Movie Catalog',
                              style: Styles.poppins30Bold.copyWith(
                                color: Palette.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Selected user: ${widget.user.fullName}',
                              style: Styles.poppins14SemiBold.copyWith(
                                color: Palette.kPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Movies and bookmarks are shown for the selected user. Use the bookmark tab to view only that user\'s saved movies.',
                              style: Styles.poppins14.copyWith(
                                color: Palette.subTextColor,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Palette.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _TabButton(
                                      label: 'Movies',
                                      isSelected: _selectedTabIndex == 0,
                                      onTap: () {
                                        setState(() {
                                          _selectedTabIndex = 0;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _TabButton(
                                      label:
                                          'Bookmarks (${state.bookmarkedMovies.length})',
                                      isSelected: _selectedTabIndex == 1,
                                      onTap: () {
                                        setState(() {
                                          _selectedTabIndex = 1;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedTabIndex == 0 && state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: _ReconnectHint(),
                        ),
                      ),
                    if (state.status == MovieStatus.loading &&
                        state.movies.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_selectedTabIndex == 0 && state.movies.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No movies available',
                            style: Styles.poppins16Medium.copyWith(
                              color: Palette.subTextColor,
                            ),
                          ),
                        ),
                      )
                    else if (_selectedTabIndex == 1 &&
                        state.bookmarkedMovies.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'No bookmarked movies for ${widget.user.fullName} yet.',
                              textAlign: TextAlign.center,
                              style: Styles.poppins16Medium.copyWith(
                                color: Palette.subTextColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverList.builder(
                          itemCount:
                              (_selectedTabIndex == 0
                                  ? state.movies.length
                                  : state.bookmarkedMovies.length) +
                              (_selectedTabIndex == 0 && state.isLoadingMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            final currentList = _selectedTabIndex == 0
                                ? state.movies
                                : state.bookmarkedMovies;

                            if (_selectedTabIndex == 0 &&
                                index >= currentList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final movie = currentList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: AnimatedCardWrapper(
                                index: index,
                                child: MovieCard(
                                  movie: movie,
                                  onBookmarkTap: () {
                                    context.read<MovieBloc>().add(
                                      ToggleMovieBookmarkEvent(
                                        user: widget.user,
                                        movie: movie,
                                        shouldBookmark: !movie.isBookmarked,
                                      ),
                                    );
                                  },
                                  onTap: () => context.push(
                                    AppRoutes.movieDetails,
                                    extra: {
                                      'user': widget.user,
                                      'movie': movie,
                                      'bloc': context.read<MovieBloc>(),
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Palette.kPrimary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Styles.poppins12SemiBold.copyWith(
            color: isSelected ? Palette.kPrimary : Palette.subTextColor,
          ),
        ),
      ),
    );
  }
}

class _ReconnectHint extends StatelessWidget {
  const _ReconnectHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Palette.kPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Reconnecting...',
          style: Styles.poppins12Medium.copyWith(color: Palette.subTextColor),
        ),
      ],
    );
  }
}
