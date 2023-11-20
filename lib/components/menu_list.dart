import 'package:flight_info_app/components/menu_card.dart';
import 'package:flight_info_app/screens/flight_list_screen.dart';
import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Menu.values.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: MenuCard(menu: e, didSelected: (m)=>{
        navigateToFlightListScreen()
      }),)).toList()
    ,);
  }

  navigateToFlightListScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FlightListScreen(),));
  }
}