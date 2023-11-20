import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/components/menu_list.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 75), child: Column(
        children: [
          const Header(),
          Expanded(child: Container(padding: const EdgeInsets.all(125), child: const MenuList(),),),
          const Footter()
        ],
      ),),
    );
  }
}
