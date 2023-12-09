import 'dart:io';

import 'package:flight_info_app/components/dialogs.dart';
import 'package:flight_info_app/components/menu_card.dart';
import 'package:flight_info_app/screens/flight_list_screen.dart';
import 'package:flight_info_app/screens/login_screen.dart';
import 'package:flight_info_app/utils/global_storage.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class MenuList extends StatefulWidget {
  final Function(Menu) didSelected;
  const MenuList({super.key, required this.didSelected});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Menu.values
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: MenuCard(
                    menu: e,
                    didSelected: (m) {
                     widget.didSelected(m);
                    }),),
              ))
          .toList(),
    );
  }
}
