import 'package:flutter/material.dart';
import 'package:platfom_commons_machine_test/features/movies/domain/entity/movie.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';
import 'package:platfom_commons_machine_test/shared/widgets/app_image.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Palette.kPrimary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: movie.posterUrl,
              width: 92,
              height: 132,
              borderRadius: BorderRadius.circular(18),
              backgroundColor: Palette.lightGrayBg,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Palette.kPrimary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          movie.releaseDate,
                          style: Styles.poppins12Medium.copyWith(
                            color: Palette.kPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onBookmarkTap,
                        icon: Icon(
                          movie.isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: Palette.orangeColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.poppins16Bold.copyWith(
                      color: Palette.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.poppins12.copyWith(
                      color: Palette.subTextColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        label: 'Rating ${movie.rating.toStringAsFixed(1)}',
                      ),
                      _MetaChip(label: movie.originalLanguage),
                      if (!movie.isSynced)
                        _MetaChip(
                          label: 'Pending sync',
                          color: Palette.orangeColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color? color;

  const _MetaChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Palette.textColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: Styles.poppins12Medium.copyWith(color: resolvedColor),
      ),
    );
  }
}
