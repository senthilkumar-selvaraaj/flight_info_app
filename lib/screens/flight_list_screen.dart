import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({super.key});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  int selectedFlightIndex = -1;
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 75),
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "FLIGHT LIST",
                                    style: TextStyle(
                                        color: theme.flightListHeaderColor),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          sectionHeader("FLIGHT", theme),
                                          sectionHeader("FLIGHT STATUS", theme),
                                          sectionHeader("BRD", theme),
                                          sectionHeader("DEP", theme),
                                          sectionHeader("ARR", theme),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(child: getFlightList(theme))
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(top: 100),
                              // color: AppColors.secondaryGrey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: ShapeDecoration(
                                          color: theme.flightInfoHintBannerBg,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      child: const Text(
                                        "Select a flight from the list then choose 'Open Flight' when ready",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        height: 45,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    theme.backgroundColor,
                                                side: const BorderSide(
                                                  width: 2.0,
                                                  color: AppColors.primaryBlue,
                                                ),
                                                shadowColor:
                                                    Colors.transparent),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Back",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: theme.loginButtonBgColor),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SizedBox(
                                        width: 130,
                                        height: 45,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    theme.loginButtonBgColor),
                                            onPressed: () {},
                                            child: const Text(
                                              "Open Flight",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.white),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Footter()
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String header, AppTheme theme) => Expanded(
      flex: 1,
      child: Text(
        header,
        textAlign: TextAlign.left,
        style:
            TextStyle(color: theme.flightListSectionHeaderColor, fontSize: 14),
      ));

  ListView getFlightList(AppTheme theme) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15, top: 7, bottom: 7),
            child: flightCard(index, theme, context,(){
              if(mounted){
                setState(() {
                  selectedFlightIndex = index;
                });
              }
            }),
          );
        }));
  }

  Widget flightCard(int index, AppTheme theme, BuildContext context, Function() didSelected) {
    return GestureDetector(
      onTap: didSelected,
      child: Container(
      decoration: getShadowShape(index, theme, context),
      height: 75.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: getFlightNo(theme),
            ),
            Expanded(flex: 1, child: getFlightStatus(theme)),
            Expanded(flex: 1, child: getBRD(index, theme)),
            Expanded(flex: 1, child: getDEP(theme)),
            Expanded(flex: 1, child: getARR(theme)),
          ],
        ),
      ),
    ),);
  }

  ShapeDecoration getShadowShape(int index, AppTheme theme, BuildContext context) {
    return ShapeDecoration(
      color: (Provider.of<ThemeNotifier>(context).isDark  && selectedFlightIndex == index) ? AppColors.primaryBlue : theme.flightInfoCardBgColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: (!Provider.of<ThemeNotifier>(context).isDark  && selectedFlightIndex == index)?  AppColors.primaryBlue : Colors.transparent , width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      shadows: Provider.of<ThemeNotifier>(context).isDark
          ? []
          : const [
              BoxShadow(
                color: Color(0x071A212B),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Color(0x141A212B),
                blurRadius: 16,
                offset: Offset(0, 12),
                spreadRadius: -4,
              )
            ],
    );
  }

  Widget getFlightNo(AppTheme theme) {
    return Text(
      "SG198",
      style: TextStyle(color: theme.flightInfoCardTextColor, fontSize: 16),
    );
  }

  Widget getFlightStatus(AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Container(
        height: 46,
        width: 100,
        decoration: ShapeDecoration(
          color: AppColors.flightStatusOnTimeBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Center(
          child: Text(
            "ONTIME",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.flightStatusOnTime, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget getBRD(int index, AppTheme theme) {
    return Text(
      "1350",
      style: TextStyle(color: (Provider.of<ThemeNotifier>(context).isDark  && selectedFlightIndex == index) ? AppColors.white : theme.flightBRDTextColor, fontSize: 16),
    );
  }

  Widget getDEP(AppTheme theme) {
    return Text(
      "BLR 1400",
      style: TextStyle(color: theme.flightInfoCardTextColor, fontSize: 16),
    );
  }

  Widget getARR(AppTheme theme) {
    return Text(
      "MMA 2020",
      style: TextStyle(color: theme.flightInfoCardTextColor, fontSize: 16),
    );
  }
}

enum FlightStatus { ontime, delayed }
