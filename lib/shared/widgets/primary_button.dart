import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../style/palette.dart';
import '../style/text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final String? loadingText;
  final bool? loading;
  final Color? borderColor;
  final TextStyle? labelStyle;
  final VoidCallback onTap;
  final String text;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;
  const PrimaryButton({
    super.key,
    this.loading = false,
    required this.onTap,
    this.loadingText,
    this.padding,
    required this.text,
    this.width,
    this.height,
    this.elevation = 0,
    this.borderRadius = 10,
    this.fontSize,
    this.textColor = Palette.white,
    this.bgColor = Palette.kPrimary,
    this.iconData,
    this.borderColor,
    this.labelStyle,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: widget.loading == true
            ? null
            : () {
                _controller.forward().then((_) => _controller.reverse());
                widget.onTap();
              },
        child: ScaleTransition(
          scale: _tween.animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
          ),
          child: Card(
            elevation: widget.elevation ?? 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            ),
            child: Container(
              height: widget.height ?? 50,
              alignment: Alignment.center,
              width: widget.width ?? double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.borderColor ?? Colors.transparent,
                ),
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              ),
              child: widget.loading == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const SizedBox(
                          height: 24,
                          width: 24,
                          child: SpinKitSpinningLines(color: Palette.white),
                        ),
                        widget.loadingText != null
                            ? Text(
                                widget.loadingText ?? "",
                                style:
                                    widget.labelStyle ??
                                    Styles.poppins12.copyWith(
                                      color: widget.textColor ?? Palette.white,
                                    ),
                              )
                            : SizedBox(),
                      ],
                    )
                  : Text(
                      widget.text,
                      style:
                          widget.labelStyle ??
                          Styles.poppins12.copyWith(
                            color: widget.textColor ?? Palette.white,
                          ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
