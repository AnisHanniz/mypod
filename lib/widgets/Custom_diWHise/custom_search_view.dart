import 'package:flutter/material.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_image_view.dart';

class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    super.key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  });

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context),
          )
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus!,
          style: textStyle,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: (String value) {
            onChanged!.call(value);
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle,
        prefixIcon: prefix ??
            Container(
              margin: const EdgeInsets.fromLTRB(17, 10, 12, 9),
              child: CustomImageView(
                imagePath: AppConstants.imageNotFound,
                height: 20,
                width: 18,
              ),
            ),
        prefixIconConstraints: prefixConstraints ??
            const BoxConstraints(
              maxHeight: 40,
            ),
        suffixIcon: suffix ??
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: IconButton(
                onPressed: () => controller!.clear(),
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        suffixIconConstraints: suffixConstraints ??
            const BoxConstraints(
              maxHeight: 40,
            ),
        isDense: true,
        contentPadding: contentPadding ??
            const EdgeInsets.only(
              top: 12,
              right: 12,
              bottom: 12,
            ),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppConstants.violet,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppConstants.violet,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppConstants.violet,
                width: 1,
              ),
            ),
      );
}
