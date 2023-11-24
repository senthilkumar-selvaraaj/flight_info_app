import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AppTextField extends StatefulWidget {
  final bool isSecured;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? hintText;
  final String? label;
  final bool readOnly;
  final TextInputType? inputType;
  final Widget? suffix;
  final Function(String?)? onChanged;
  final Function(String?)? validator;
  final Function()? onTpped;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField(
      {super.key,
      this.hintText,
      this.label,
      this.style,
      this.readOnly = false,
      this.isSecured = false,
      this.inputFormatters = const [],
      this.inputType = TextInputType.text,
      this.suffix,
      this.controller,
      this.validator,
      this.onChanged,
      this.onTpped,
      });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return TextFormField(
      controller: widget.controller,
       readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.inputType,
        obscureText: widget.isSecured,
        obscuringCharacter: 'x',
        style: TextStyle(fontSize: 14, color: theme.textFiledTextColor, fontWeight:FontWeight.w600),
        decoration: InputDecoration(
            suffixIcon: widget.suffix,
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: widget.label,
            labelStyle: TextStyle(color:theme.placeholderColor, fontSize: 14, fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.only(left: 25, right: 25),
            border: InputBorder.none
           ),
        onChanged: (value) {
          widget.onChanged!(value);
        },
        onTap: () => widget.onTpped !=  null ? widget.onTpped!() : null,
        validator: (value) => widget.validator!(value));
  }
}



class SearchFromField extends StatefulWidget {
  final bool isSecured;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? hintText;
  final String? label;
  final bool readOnly;
  final TextInputType? inputType;
  final Widget? suffix;
  final Function(String?)? onChanged;
  final Function(String?)? validator;
  final Function()? onTpped;
  final List<TextInputFormatter>? inputFormatters;
  const SearchFromField(
      {super.key,
      this.hintText,
      this.label,
      this.style,
      this.readOnly = false,
      this.isSecured = false,
      this.inputFormatters = const [],
      this.inputType = TextInputType.text,
      this.suffix,
      this.controller,
      this.validator,
      this.onChanged,
      this.onTpped,
      });

  @override
  State<SearchFromField> createState() => _SearchFromFieldState();
}

class _SearchFromFieldState extends State<SearchFromField> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return TextFormField(
      controller: widget.controller,
       readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.inputType,
        obscureText: widget.isSecured,
        obscuringCharacter: 'x',
        style: TextStyle(fontSize: 14, color: theme.textFiledTextColor, fontWeight:FontWeight.w500),
        decoration: InputDecoration(
            suffixIcon: widget.suffix,
            hintText: widget.hintText,
            hintStyle: TextStyle(color:theme.placeholderColor, fontSize: 14, fontWeight: FontWeight.w500),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: widget.label,
            labelStyle: TextStyle(color:theme.placeholderColor, fontSize: 14, fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
            border: InputBorder.none
           ),
        onChanged: (value) {
          widget.onChanged!(value);
        },
        onTap: () => widget.onTpped !=  null ? widget.onTpped!() : null,
        validator: (value) => widget.validator!(value));
  }
}
