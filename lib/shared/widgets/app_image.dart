import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isSliver = false,
    this.progressColor,
    this.errorIconColor,
    this.backgroundColor,
    this.placeholderColor,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isSliver;
  final Color? progressColor;
  final Color? errorIconColor;
  final Color? backgroundColor;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final child = _buildImage(context);
    if (isSliver) return SliverToBoxAdapter(child: child);
    return child;
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);

    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      progressIndicatorBuilder: (context, url, progress) => _Placeholder(
        width: width,
        height: height,
        bgColor: placeholderColor ?? theme.colorScheme.surfaceContainerHighest,
        child: CircularProgressIndicator(
          value: progress.progress,
          strokeWidth: 2.5,
          color: progressColor ?? theme.colorScheme.primary,
        ),
      ),
      errorWidget: (context, url, error) => _ErrorPlaceholder(
        width: width,
        height: height,
        bgColor: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        iconColor: errorIconColor ?? Colors.red.shade300,
      ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    if (backgroundColor != null) {
      image = ColoredBox(color: backgroundColor!, child: image);
    }

    return image;
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.child,
    required this.bgColor,
    this.width,
    this.height,
  });

  final Widget child;
  final Color bgColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({
    required this.bgColor,
    required this.iconColor,
    this.width,
    this.height,
  });

  final Color bgColor;
  final Color iconColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: bgColor,
      alignment: Alignment.center,
      child: Icon(EvaIcons.image, color: Palette.gray),
    );
  }
}
