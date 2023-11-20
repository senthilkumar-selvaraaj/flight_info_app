import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoPlaceHolder extends StatefulWidget {
  const LogoPlaceHolder({super.key});

  @override
  State<LogoPlaceHolder> createState() => _LogoPlaceHolderState();
}

class _LogoPlaceHolderState extends State<LogoPlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(Provider.of<ThemeNotifier>(context).isDark ? 'assets/icons/logo-dark.png' : 'assets/icons/logo-light.png'));
  }
}