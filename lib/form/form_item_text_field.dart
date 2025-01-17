part of masamune.form;

class FormItemTextField extends StatelessWidget implements FormItem {
  const FormItemTextField({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onTap,
    this.minLength,
    this.contentPadding,
    this.maxLines,
    this.minLines = 1,
    this.border,
    this.disabledBorder,
    this.backgroundColor,
    this.expands = false,
    this.hintText,
    this.labelText,
    this.lengthErrorText = "",
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.dense = false,
    this.padding,
    this.suggestion = const [],
    this.allowEmpty = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.counterText = "",
    this.onDeleteSuggestion,
    this.validator,
    this.inputFormatters,
    this.onSaved,
    this.onSubmitted,
    this.onChanged,
    this.showCursor,
    this.focusNode,
    this.color,
    this.fontSize,
    this.subColor,
    this.height,
    this.errorText,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? minLength;
  final int? maxLines;
  final double? height;
  final int minLines;
  final Color? cursorColor;
  final bool dense;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final String? lengthErrorText;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final String? prefixText;
  final String? suffixText;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool readOnly;
  final bool obscureText;
  final bool expands;
  final bool allowEmpty;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final List<String> suggestion;
  final Color? backgroundColor;
  final void Function(String value)? onDeleteSuggestion;
  final void Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? color;
  final Color? subColor;
  final bool? showCursor;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? value)? onSubmitted;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return SuggestionOverlayBuilder(
      items: suggestion,
      onDeleteSuggestion: onDeleteSuggestion,
      controller: controller,
      focusNode: focusNode,
      builder: (context, controller, onTap) => Container(
        height: height,
        padding: padding ??
            (dense
                ? const EdgeInsets.symmetric(vertical: 20)
                : const EdgeInsets.symmetric(vertical: 10)),
        child: TextFormField(
          cursorColor: cursorColor,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          showCursor: showCursor,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : (expands ? null : maxLines),
          minLines: obscureText ? 1 : (expands ? null : minLines),
          expands: !obscureText && expands,
          decoration: InputDecoration(
            contentPadding: contentPadding ??
                (dense
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 0)
                    : null),
            fillColor: backgroundColor,
            filled: backgroundColor != null,
            isDense: dense,
            border: border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            enabledBorder: border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            disabledBorder: disabledBorder ??
                border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            errorBorder: border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            focusedBorder: border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            focusedErrorBorder: border ??
                OutlineInputBorder(
                  borderSide: dense ? BorderSide.none : const BorderSide(),
                ),
            hintText: hintText,
            labelText: labelText,
            counterText: counterText,
            prefix: prefix,
            suffix: suffix,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixText: prefixText,
            suffixText: suffixText,
            prefixIconConstraints: prefixIconConstraints,
            suffixIconConstraints: suffixIconConstraints,
            labelStyle: TextStyle(
                color: color ?? context.theme.textColor, fontSize: fontSize),
            hintStyle: TextStyle(
                color: subColor ??
                    color?.withOpacity(0.5) ??
                    context.theme.textColor.withOpacity(0.5),
                fontSize: fontSize),
            suffixStyle: TextStyle(
                color: subColor ??
                    color?.withOpacity(0.5) ??
                    context.theme.textColor.withOpacity(0.5),
                fontSize: fontSize),
            prefixStyle: TextStyle(
                color: subColor ??
                    color?.withOpacity(0.5) ??
                    context.theme.textColor.withOpacity(0.5),
                fontSize: fontSize),
            counterStyle: TextStyle(
                color: subColor ??
                    color?.withOpacity(0.5) ??
                    context.theme.textColor.withOpacity(0.5),
                fontSize: fontSize),
            helperStyle: TextStyle(
                color: subColor ??
                    color?.withOpacity(0.5) ??
                    context.theme.textColor.withOpacity(0.5),
                fontSize: fontSize),
          ),
          style: TextStyle(
              color: color ?? context.theme.textColor, fontSize: fontSize),
          obscureText: obscureText,
          readOnly: readOnly,
          onFieldSubmitted: (value) {
            onSubmitted?.call(value);
          },
          onTap: enabled
              ? () {
                  if (this.onTap != null) {
                    this.onTap?.call();
                  } else {
                    onTap.call();
                  }
                }
              : null,
          validator: (value) {
            if (!allowEmpty && errorText.isNotEmpty && value.isEmpty) {
              return errorText;
            }
            if (!allowEmpty &&
                lengthErrorText.isNotEmpty &&
                minLength.def(0) > value.length) {
              return lengthErrorText;
            }
            return validator?.call(value);
          },
          onChanged: onChanged,
          onSaved: (value) {
            if (!allowEmpty && value.isEmpty) {
              return;
            }
            onSaved?.call(value);
          },
        ),
      ),
    );
  }
}
