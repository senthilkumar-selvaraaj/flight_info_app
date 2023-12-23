import 'package:flight_info_app/components/status_icon.dart';
import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/services/socket_notifier.dart';
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
        StatusIcon(icon: Icons.contrast, showBadge: false, toolTipMessage: "Switch to ${Provider.of<ThemeNotifier>(context).isDark ? "Light" : "Dark"} Mode"),
        const StatusIcon(icon: Icons.flight,  toolTipMessage: "Airline DCS", showBadge: false,),
        allLanes.isEmpty ? const SizedBox() :  StatusIcon(icon: Icons.dns,  toolTipMessage: "Boarding Gate", badgeColor: Provider.of<SocketStatusNotifier>(context).connectionState.getColor(),),
    ],);
  }
}


enum StatusIconMenu{
  theme, airline, gate
}