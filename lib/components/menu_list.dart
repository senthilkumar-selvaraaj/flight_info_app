
import 'package:aai_chennai/components/menu_card.dart';
import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  final Function(Menu) didSelected;
  const MenuList({super.key, required this.didSelected});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
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
