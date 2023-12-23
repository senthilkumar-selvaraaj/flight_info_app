import 'package:flight_info_app/components/app_buttons.dart';
import 'package:flight_info_app/components/dialogs.dart';
import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/models/lane.dart';
import 'package:flight_info_app/screens/login_screen.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaneScreen extends StatefulWidget {
  const LaneScreen({super.key});

  @override
  State<LaneScreen> createState() => _LaneScreenState();
}

class _LaneScreenState extends State<LaneScreen> {
  List<Lane> lanes = [];
  @override
  void initState() {
    super.initState();
    fetchLanes();
  }

  void fetchLanes() {
    final l = database.store.box<Lane>().getAll();
    setState(() {
      lanes = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 75),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                "SETTINGS",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: theme.flightListHeaderColor),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Image(
                      image: AssetImage('assets/images/flight-pic.jpg'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(flex: 5, child: getGridView(context, theme))
                ],
              ),
            ),
            const Footter()
          ],
        ),
      ),
    );
  }

  Widget getGridView(BuildContext context, AppTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: GridView.count(
          primary: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: (235 / 165),
          crossAxisCount: 3,
          children: List.generate(
            lanes.length + 1,
            (index) => index < lanes.length
                ? laneCard(context, theme, index)
                : addNewLaneCard(context, theme, index),
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [FilledActionButton(title: "FINISH", didTapped: () {

              if(lanes.isNotEmpty){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeScreen()));
              }

            })],
          ),
        )
      ],
    );
  }

  Widget laneCard(BuildContext context, AppTheme theme, int index) {
    return GestureDetector(
        onTap: () {
          // Dialogs.showLaneDialog(context, theme, () => {}, () => {});
        },
        child: Focus(
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: theme.menuCardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: Provider.of<ThemeNotifier>(context).isDark
                                ? BorderSide.none
                                : const BorderSide(
                                    color: AppColors.lightGrey, width: 2)),
                        shadows: const [],
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: theme.laneColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            height: 50,
                            width: 50,
                            child: Center(
                                child: Image(
                              image: AssetImage(
                                  'assets/icons/icon-lane-${Provider.of<ThemeNotifier>(context).isDark ? 'dark' : 'light'}.png'),
                              fit: BoxFit.cover,
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                lanes[index].name ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.dateTimeColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Device ID: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: theme.dateTimeColor),
                                  ),
                                 Expanded(child:  Text(
                                    lanes[index].deviceId ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      
                                        color: theme.flightBRDTextColor),
                                  ))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Visibility(visible: index == lanes.length-1, child: Positioned(top: 0, right: 0, child: GestureDetector(
                    onTap: (){
                      database.store.box<Lane>().remove(lanes[index].id);
                      fetchLanes();
                    },
                    child: Container( decoration: ShapeDecoration(
                         color: theme.flightBRDTextColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            ),
                      ), height: 30, width: 30, child: const Center(child: Icon(Icons.close, color: Colors.white, size: 15,)),),)))
                ],
              )),
        ));
  }

  Widget addNewLaneCard(BuildContext context, AppTheme theme, int index) {
    return GestureDetector(
        onTap: () {
          Dialogs.showLaneDialog(
              context, "Lane ${(lanes.length+1).toString().padLeft(2, '0')}", theme, () => {}, () => {fetchLanes()});
        },
        child: Focus(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: theme.menuCardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: Provider.of<ThemeNotifier>(context).isDark
                          ? BorderSide.none
                          : const BorderSide(
                              color: AppColors.lightGrey, width: 2)),
                  shadows: const [],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        color: theme.flightBRDTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      height: 45,
                      width: 45,
                      child: const Center(
                          child: Image(
                        image: AssetImage('assets/icons/icon-plus.png'),
                        fit: BoxFit.cover,
                      )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Add New Lane',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: theme.flightBRDTextColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
