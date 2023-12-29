import 'package:aai_chennai/components/app_buttons.dart';
import 'package:aai_chennai/components/app_text_field.dart';
import 'package:aai_chennai/main.dart';
import 'package:aai_chennai/models/lane.dart';
import 'package:aai_chennai/services/lane_service.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaneView extends StatefulWidget {
  final Function() didNewLaneAdded;
  final String laneName;

  const LaneView(
      {super.key, required this.laneName, required this.didNewLaneAdded});

  @override
  State<LaneView> createState() => _LaneViewState();
}

class _LaneViewState extends State<LaneView> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController deviceIDController = TextEditingController();
  bool showErrorView = false;
  String errorMEssage = "";
  @override
  void initState() {
    super.initState();
    nameTextController.text = widget.laneName;
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add New Lane",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: theme.loginHeaderColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 140,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(color: theme.laneBorderColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: getNameTextField(),
              ),
              SizedBox(
                height: 2,
                child: Divider(
                  color: theme.laneBorderColor,
                ),
              ),
              Expanded(child: getDeviceIDTextField()),
            ],
          ),
        ),
         Visibility(
            visible: showErrorView,
            child:  Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMEssage,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            )),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            CancelActionButton(
                height: 40,
                title: "Cancel",
                didTapped: () {
                  Navigator.of(context).pop();
                  //didCanceled();
                }),
            const SizedBox(
              width: 15,
            ),
            ConfirmActionButton(
                height: 40,
                title: "Add",
                didTapped: () {
                  if(deviceIDController.text.isEmpty){
                    setState(() {
                      errorMEssage = 'Please enter Device Id';
                      showErrorView = true;
                    });
                    return;
                  } 

                  if(LaneService.isExist(deviceIDController.text)){
                    setState(() {
                      errorMEssage = 'Device Id already exist';
                      showErrorView = true;
                    });
                      return;
                    }
                  final laneBox = database.store.box<Lane>();
                  final lane = Lane();
                  lane.name = nameTextController.text;
                  lane.deviceId = deviceIDController.text;
                  laneBox.put(lane);
                  allLanes = LaneService.getLanes();
                  widget.didNewLaneAdded();
                  Navigator.of(context).pop();
                })
          ],
        )
      ],
    );
  }

  Widget getNameTextField() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          AppTextField(
            controller: nameTextController,
            readOnly: true,
            label: "Lane Number",
            onChanged: (p0) {
            },
          ),
        ],
      ),
    );
  }

  Widget getDeviceIDTextField() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          // textFieldLabel('Password'),
          AppTextField(
            controller: deviceIDController,
            label: "Device ID",
            onChanged: (p0) {
              if(!(p0?.isEmpty ?? false)){
                  setState(() {
                    showErrorView = false;
                  });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget textFieldLabel(String text) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        text,
        style: TextStyle(color: theme.placeholderColor, fontSize: 14),
      ),
    );
  }

  navigateToDashBoard() {}
}
