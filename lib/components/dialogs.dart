
import 'package:flight_info_app/components/app_buttons.dart';
import 'package:flight_info_app/components/lane_view.dart';
import 'package:flight_info_app/components/login_view.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';

class Dialogs {
  
 static Future<void> showAlertDialog(BuildContext context, DialogType type, AppTheme theme, Function() didCanceled, Function () didConfirmed ) async{
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        title: const SizedBox(),
        content:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(type.getImageName()), color: theme.menuIconColor,),
              const SizedBox(height: 25,),
              Text(type.getTitle(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: theme.flightInfoCardTextColor , fontWeight: FontWeight.w500) ,),
              const SizedBox(height: 10,),
              Text(type.getSubTitle(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14,  color: theme.flightInfoCardTextColor)),
              const SizedBox(height: 10,),
            ],
          ),
        ),
        actions: <Widget>[
          Row(children: [CancelActionButton(height: 40, title: "Cancel", didTapped: (){
            Navigator.of(context).pop();
            didCanceled();
          } ), const SizedBox(width: 15,), ConfirmActionButton(height: 40, title: "Confirm", didTapped: (){
             Navigator.of(context).pop();
            didConfirmed();
          })],)
        ],
      );
    },
  );
  }

  static Future<void> showLaneDialog(BuildContext context, String laneName, AppTheme theme, Function() didCanceled, Function () didConfirmed ) async{
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        title: const SizedBox(),
        content:   SingleChildScrollView(
          child:  LaneView(laneName: laneName, didNewLaneAdded: didConfirmed,),
        ),
      );
    },
  );
  }

}

enum DialogType{
  logout, exit, endBoarding;

  String getImageName(){
    switch (this){
      case DialogType.logout:
      return 'assets/icons/icon-logout.png';
      case DialogType.exit:
      return 'assets/icons/icon-logout.png';
      case DialogType.endBoarding:
      return 'assets/icons/end-boarding.png';
    }
  } 

String getTitle(){
    switch (this){
      case DialogType.endBoarding:
      return 'End Boarding';
      case DialogType.exit:
      return 'Confirm to Exit';
      case DialogType.logout:
      return 'Confirm to Log out';
    }
  } 

  String getSubTitle(){
    switch (this){
      case DialogType.logout:
      return 'Are you sure you want to log out?\nThis will end the current session\nand make the gate available to other users';
      case DialogType.exit:
      return 'Are you sure you want to exit?\nThis will end the current session';
      case DialogType.endBoarding:
      return 'This will end flight booarding on E-gate.\nPlease ensure airside exit is secure';
    }
  } 

}