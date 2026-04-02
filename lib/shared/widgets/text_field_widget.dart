import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/palette.dart';
import '../style/text_styles.dart';

class AppTextField extends StatefulWidget {
  final Color? bgColor;
  final bool? obscureText;
  final TextStyle? hintTextStyle;
  final String? name;
  final String? hintText;
  final double? borderRadius;
  final Color? focusedBorderColor;
  final Color? cursorColor;
  final String? label;
  final Widget? labelWidget;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Function(String)? onSubmitted;
  final Function? function;
  final FocusNode? focusNode;
  final bool floating;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool? suffixDropDown;
  final Function? onTapFunction;
  final int? maxLine;
  final int? maxLength;
  final EdgeInsetsGeometry? edgeInsets;
  final EdgeInsetsGeometry? padding;
  final Widget? iconWithFunction;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool isFilled;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final bool isBorderNeeded;
  final bool isPrefixTextNeeded;
  final bool? enabled;
  final String? counterText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? enabledBorderColor;
  final Color? textColor;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? expands;

  const AppTextField({
    this.textColor,
    this.onSubmitted,

    super.key,
    this.expands,
    this.counterText,
    this.hintText,
    this.borderColor = Palette.borderLitColor,
    this.isBorderNeeded = true,
    this.isPrefixTextNeeded = false,
    this.validator,
    this.borderRadius,
    this.name,
    this.label,
    this.labelWidget,
    this.isFilled = false,
    this.fillColor,
    this.controller,
    this.textInputType,
    this.suffixIcon,
    this.function,
    this.focusNode,
    this.floating = false,
    this.inputFormatters,
    this.textInputAction,
    this.textCapitalization,
    this.suffixDropDown,
    this.readOnly = false,
    this.onTapFunction,
    this.maxLine,
    this.maxLength,
    this.edgeInsets,
    this.padding,
    this.iconWithFunction,
    this.prefixWidget,
    this.textStyle,
    this.cursorColor,
    this.hintTextStyle,
    this.enabled,
    this.bgColor,
    this.focusedBorderColor,
    this.contentPadding,
    this.enabledBorderColor,
    this.obscureText,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !(widget.obscureText ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      margin: widget.edgeInsets ?? const EdgeInsets.all(0),
      child: TextFormField(
        onFieldSubmitted: widget.onSubmitted,
        expands: widget.expands ?? false,
        enabled: widget.enabled,
        cursorColor: widget.cursorColor,
        readOnly: widget.readOnly,
        validator: widget.validator,
        onTap: () => widget.onTapFunction?.call(),
        inputFormatters: widget.inputFormatters,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        keyboardType: widget.textInputType,
        controller: widget.controller,
        obscureText: widget.obscureText == true ? !_passwordVisible : false,
        enableSuggestions: false,
        autocorrect: false,
        style: Styles.poppins12.copyWith(color: widget.textColor),
        focusNode: widget.focusNode,
        maxLines: widget.maxLine ?? 1,
        maxLength: widget.maxLength ?? 500,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          filled: widget.isFilled,
          fillColor: widget.isFilled ? widget.fillColor : Palette.white,
          label: widget.labelWidget,
          errorText: null,
          isDense: true,
          labelText: widget.maxLine == null
              ? widget.name ?? widget.label
              : widget.label,
          hintText: widget.hintText,
          counterText: widget.counterText ?? "",
          hintStyle: widget.hintTextStyle ?? Styles.poppins12,
          labelStyle: widget.textStyle ?? Styles.poppins12,
          border: widget.isBorderNeeded
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Palette.borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
                )
              : InputBorder.none,
          enabledBorder: widget.isBorderNeeded
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.enabledBorderColor ??
                        widget.borderColor ??
                        Palette.borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
                )
              : null,
          focusedBorder: widget.isBorderNeeded
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.focusedBorderColor ?? Palette.kPrimary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
                )
              : null,
          floatingLabelBehavior: widget.floating
              ? FloatingLabelBehavior.always
              : null,
          prefixIcon: widget.prefixWidget,
          prefixText: widget.isPrefixTextNeeded ? '\$' : null,
          suffixIcon: _buildSuffixIcon(),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText == true) {
      return IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      );
    } else if (widget.suffixDropDown == true &&
        widget.iconWithFunction != null) {
      return widget.iconWithFunction;
    } else if (widget.suffixDropDown == true) {
      return const Icon(
        Icons.arrow_drop_down_outlined,
        size: 25,
        color: Palette.darkGray,
      );
    } else {
      return widget.suffixIcon;
    }
  }
}
