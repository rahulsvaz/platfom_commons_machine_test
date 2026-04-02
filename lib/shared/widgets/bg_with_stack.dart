import 'package:flutter/cupertino.dart';

import '../style/palette.dart';

class BackGroundWithStack extends StatelessWidget {
  const BackGroundWithStack({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          top: -size.width * 0.40,
          right: -size.width * 0.28,
          child: Container(
            width: size.width * 1.0,
            height: size.width * 1.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.kPrimary.withValues(alpha: 0.07),
            ),
          ),
        ),
        Positioned(
          bottom: -size.width * 0.28,
          left: -size.width * 0.18,
          child: Container(
            width: size.width * 0.72,
            height: size.width * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.kPrimary.withValues(alpha: 0.04),
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
