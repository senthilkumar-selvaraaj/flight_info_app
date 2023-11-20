import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PowerdBy extends StatelessWidget {
  const PowerdBy({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return  Row(children: [
      Text("Powered By ", style: TextStyle(color: theme.poweredByColor, fontSize: 15, fontWeight: FontWeight.w300,),),
      Text("ELENIUM",  style: TextStyle(color: theme.poweredByColor, fontSize: 15, fontWeight: FontWeight.w700))
    ],);
  }
}