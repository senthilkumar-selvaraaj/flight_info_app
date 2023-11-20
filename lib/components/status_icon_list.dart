import 'package:flight_info_app/components/status_icon.dart';
import 'package:flutter/material.dart';

class StatusList extends StatefulWidget {
  const StatusList({super.key});

  @override
  State<StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  @override
  Widget build(BuildContext context) {
    return  const Row(children: [
       StatusIcon(icon: Icons.contrast, showBadge: false,),
       StatusIcon(icon: Icons.flight,),
       StatusIcon(icon: Icons.settings,),
       StatusIcon(icon: Icons.monitor,)
    ],);
  }
}