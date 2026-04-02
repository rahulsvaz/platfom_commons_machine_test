import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';
import 'package:platfom_commons_machine_test/shared/widgets/app_back_button.dart';
import 'package:platfom_commons_machine_test/shared/widgets/app_image.dart';
import 'package:platfom_commons_machine_test/shared/widgets/bg_with_stack.dart';
import 'package:platfom_commons_machine_test/shared/widgets/network_status_chip.dart';

class MovieDetailsPage extends StatefulWidget {
  final User user;
  final Movie movie;

  const MovieDetailsPage({super.key, required this.user, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(
      LoadMovieDetailsEvent(
        movieId: widget.movie.id,
        fallbackMovie: widget.movie,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        final movie = state.selectedMovie?.id == widget.movie.id
            ? state.selectedMovie!
            : widget.movie;

        return Scaffold(
          backgroundColor: Palette.lightGrayBg,
          body: BackGroundWithStack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [AppBackButton(), NetworkStatusChip()],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: AppImage(
                          url: movie.backdropUrl.isNotEmpty
                              ? movie.backdropUrl
                              : movie.posterUrl,
                          height: 240,
                          width: double.infinity,
                          backgroundColor: Palette.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: Styles.poppins30Bold.copyWith(
                                color: Palette.textColor,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<MovieBloc>().add(
                                ToggleMovieBookmarkEvent(
                                  user: widget.user,
                                  movie: movie,
                                  shouldBookmark: !movie.isBookmarked,
                                ),
                              );
                            },
                            icon: Icon(
                              movie.isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: Palette.orangeColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _DetailChip(label: 'Release ${movie.releaseDate}'),
                          _DetailChip(
                            label: 'Rating ${movie.rating.toStringAsFixed(1)}',
                          ),
                          _DetailChip(label: movie.originalLanguage),
                          if (!movie.isSynced)
                            const _DetailChip(
                              label: 'Pending sync',
                              color: Palette.orangeColor,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Overview',
                        style: Styles.poppins18Bold.copyWith(
                          color: Palette.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.overview,
                        style: Styles.poppins14.copyWith(
                          color: Palette.subTextColor,
                          height: 1.7,
                        ),
                      ),
                      if (state.isLoadingDetails) ...[
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final Color color;

  const _DetailChip({required this.label, this.color = Palette.kPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(label, style: Styles.poppins12Medium.copyWith(color: color)),
    );
  }
}
