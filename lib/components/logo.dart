import 'package:aai_chennai/utils/global_storage.dart';
import 'package:aai_chennai/utils/themes.dart';
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
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    String url = isDark ? Global.storage.getDarkLogo() : Global.storage.getLightLogo();
    return url.isEmpty ?  Image(image: AssetImage('assets/icons/logo-${isDark ? 'dark' : 'light'}.png')): Image.network(url);
  }
}//