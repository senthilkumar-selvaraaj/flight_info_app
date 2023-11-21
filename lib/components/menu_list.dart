import 'package:flight_info_app/components/menu_card.dart';
import 'package:flight_info_app/screens/flight_list_screen.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
        AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Menu.values.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: MenuCard(menu: e, didSelected: (m)=>{
        if(m == Menu.flightList){
          navigateToFlightListScreen()
        }else if(m == Menu.logOut){
          _showMyDialog(theme)
        }else if(m == Menu.exit){
          
        }
      }),)).toList()
    ,);
  }

  navigateToFlightListScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FlightListScreen(),));
  }

  Future<void> _showMyDialog(AppTheme theme) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: theme.backgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        title: const SizedBox(),
        content:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(Menu.logOut.getImageName())),
              SizedBox(height: 25,),
              const Text('Confirm to exit?', textAlign: TextAlign.center,),
              const Text('Are you sure you want to exit?\nThis will end the current session.', textAlign: TextAlign.center,),
              SizedBox(height: 10,),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}