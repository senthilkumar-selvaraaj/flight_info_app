import 'package:flight_info_app/components/status_icon.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusList extends StatefulWidget {
  const StatusList({super.key});

  @override
  State<StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  @override
  Widget build(BuildContext context) {
        AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Row(children:  [
       Tooltip(decoration: BoxDecoration(color: theme.popOverBackgroundColor, borderRadius: BorderRadius.circular(5)), preferBelow: false, message: "Switch to ${Provider.of<ThemeNotifier>(context).isDark ? "Light" : "Dark"} Mode", child: StatusIcon(icon: Icons.contrast, showBadge: false,)),
       const StatusIcon(icon: Icons.flight,),
       const StatusIcon(icon: Icons.settings,),
       const StatusIcon(icon: Icons.monitor,)
    ],);
  }
}