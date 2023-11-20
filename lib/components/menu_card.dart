import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatefulWidget {
  final Menu menu;
  final Function(Menu) didSelected;
  const MenuCard({super.key, required this.menu, required this.didSelected});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  Color backgroundColor = Colors.grey;
  bool isActive = false;
  
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return MouseRegion(onEnter: (event) {
      setState(() {
        isActive = true;
      });
    },onExit: (event) {
      setState(() {
        isActive = false;
      });
    }, child: GestureDetector(onTap: () {
        widget.didSelected(widget.menu);
    }, child: Container(
      height: 325,
      width: 250,
      decoration: ShapeDecoration(
        color: isActive ? AppColors.primaryBlue : theme.menuCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [],
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage(widget.menu.getImageName()), color: isActive ? AppColors.white : theme.menuIconColor,),
          const SizedBox(height: 30,),
          Text(
            widget.menu.getTitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isActive ? AppColors.white : theme.menuTitleColor,
                fontSize: 18.0,),
          )
        ],
      ),
    ),),);
  }
}

enum Menu{
   flightList, logOut, exit;

  String getTitle(){
    switch (this) {
      case Menu.flightList:
        return "Flight List";
      case Menu.logOut:
        return "Log Out";
      case Menu.exit:
        return "Exit";
    }
  }
 String getImageName(){
    switch (this) {
      case Menu.flightList:
        return "assets/icons/icon-flight.png";
      case Menu.logOut:
        return "assets/icons/icon-logout.png";
      case Menu.exit:
        return "assets/icons/icon-exit.png";
    }
  }
}