import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final Color textColor;
  final Color colorHint;
  final TextEditingController controller;
  final Color borderColor;
  final double borderRadius;
  final Widget suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color fillColor;
  final int maxLength;
  final bool readOnly;
  final double heighText;
  final double fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: textColor ?? Colors.black54, height: heighText ?? 1.0 , fontSize: fontSize ?? 12.0),
      controller: controller,
      autocorrect: true,
      enableSuggestions: false,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint ?? 'Type Text Here...',
        hintStyle: TextStyle(color: colorHint ?? Colors.grey),
        filled: true,
        fillColor: fillColor ?? Colors.white70,
        suffixIcon: suffixIcon ?? null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 12.0)),
          borderSide: BorderSide(color: Colors.black12, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: borderColor ?? Colors.black12),
        ),
      ),
    );
  }

  TextFieldWidget(this.controller,
      {Key key,
        this.hint,
        this.colorHint,
        this.borderColor,
        this.borderRadius,
        this.suffixIcon,
        this.textColor,
        this.obscureText,
        this.keyboardType,
        this.fillColor,
        this.readOnly,
        this.fontSize,
        this.heighText,
        this.maxLength,
        this.maxLines
      })
      : assert(controller != null),
        super(key: key);
}