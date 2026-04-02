import 'package:flutter/material.dart';
import 'palette.dart';

class Styles {
  Styles._();

  static const String poppins = "Poppins";

  static TextStyle _style({
    double? size,
    FontWeight? weight,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: poppins,
      fontSize: size,
      fontWeight: weight,
      color: color ?? Palette.blackColor,
      decoration: decoration,
    );
  }

  static final poppins12 = _style(size: 12, weight: FontWeight.w400);
  static final poppins14 = _style(size: 14, weight: FontWeight.w400);
  static final poppins16 = _style(size: 16, weight: FontWeight.w400);
  static final poppins18 = _style(size: 18, weight: FontWeight.w400);
  static final poppins20 = _style(size: 20, weight: FontWeight.w400);

  static final poppins12Medium = _style(size: 12, weight: FontWeight.w500);
  static final poppins14Medium = _style(size: 14, weight: FontWeight.w500);
  static final poppins16Medium = _style(size: 16, weight: FontWeight.w500);
  static final poppins18Medium = _style(size: 18, weight: FontWeight.w500);
  static final poppins20Medium = _style(size: 20, weight: FontWeight.w500);

  static final poppins12SemiBold = _style(size: 12, weight: FontWeight.w600);
  static final poppins14SemiBold = _style(size: 14, weight: FontWeight.w600);
  static final poppins16SemiBold = _style(size: 16, weight: FontWeight.w600);
  static final poppins18SemiBold = _style(size: 18, weight: FontWeight.w600);
  static final poppins20SemiBold = _style(size: 20, weight: FontWeight.w600);

  static final poppins12Bold = _style(size: 12, weight: FontWeight.w700);
  static final poppins14Bold = _style(size: 14, weight: FontWeight.w700);
  static final poppins16Bold = _style(size: 16, weight: FontWeight.w700);
  static final poppins18Bold = _style(size: 18, weight: FontWeight.w700);
  static final poppins20Bold = _style(size: 20, weight: FontWeight.w700);
  static final poppins30Bold = _style(size: 30, weight: FontWeight.w700);
  static final poppins40Bold = _style(size: 40, weight: FontWeight.w700);

  static final poppins14White = _style(size: 14, color: Palette.white);

  static final poppins16White = _style(size: 16, color: Palette.white);

  static final poppins20White = _style(size: 20, color: Palette.white);

  static final poppins14Grey = _style(size: 14, color: Palette.darkGray);

  static final poppins12Grey = _style(size: 12, color: Palette.gray);

  static final poppins14Primary = _style(
    size: 14,
    color: Palette.kPrimary,
    weight: FontWeight.w500,
  );

  static final poppins20Primary = _style(
    size: 20,
    color: Palette.kPrimary,
    weight: FontWeight.w600,
  );

  static final poppins14Red = _style(
    size: 14,
    color: Palette.redColor,
    weight: FontWeight.w500,
  );

  static final poppins14Green = _style(
    size: 14,
    color: Palette.green,
    weight: FontWeight.w500,
  );

  static final poppins14Yellow = _style(
    size: 14,
    color: Palette.yellowColor,
    weight: FontWeight.w500,
  );

  static final poppinsTextField = _style(
    size: 15,
    weight: FontWeight.w600,
    color: Palette.textColor,
  );

  static final poppinsHint = _style(
    size: 14,
    weight: FontWeight.w500,
    color: Palette.darkHint,
  );

  static final poppinsLabel = _style(
    size: 14,
    weight: FontWeight.w500,
    color: Palette.darkHint,
  );

  static final poppinsLineThrough = _style(
    size: 12,
    decoration: TextDecoration.lineThrough,
    color: Palette.gray,
  );

  static final poppinsUnderlineRed = _style(
    size: 13,
    decoration: TextDecoration.underline,
    color: Palette.redColor,
  );

  static TextStyle poppinsDynamic({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) {
    return _style(size: size, weight: weight, color: color);
  }
}
