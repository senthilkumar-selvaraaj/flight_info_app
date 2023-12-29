import 'package:aai_chennai/components/status_icon.dart';
import 'package:aai_chennai/main.dart';
import 'package:aai_chennai/services/socket_notifier.dart';
import 'package:aai_chennai/utils/global_storage.dart';
import 'package:aai_chennai/utils/themes.dart';
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
    return Row(children:  [
        StatusIcon(icon: Icons.contrast, showBadge: false, toolTipMessage: "Switch to ${Provider.of<ThemeNotifier>(context).isDark ? "Light" : "Dark"} Mode"),
        Global.storage.hasUserLogined ?  const StatusIcon(icon: Icons.flight,  toolTipMessage: "Airline DCS", showBadge: true, badgeColor: Colors.green,) : const SizedBox(),
        allLanes.isEmpty ? const SizedBox() :  StatusIcon(icon: Icons.dns,  toolTipMessage: "Boarding Gate", badgeColor: Provider.of<SocketStatusNotifier>(context).connectionState.getColor(),),
    ],);
  }
}


enum StatusIconMenu{
  theme, airline, gate
}