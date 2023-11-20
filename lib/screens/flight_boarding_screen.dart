import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlightBoardingScreen extends StatefulWidget {
  const FlightBoardingScreen({super.key});

  @override
  State<FlightBoardingScreen> createState() => _FlightBoardingScreenState();
}

class _FlightBoardingScreenState extends State<FlightBoardingScreen> {
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
                            flex: 10,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "FLIGHT MANIFEST",
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
                                          Expanded(flex: 1, child:sectionHeader("SEQ", theme)),
                                          Expanded(flex: 2, child:sectionHeader("PNR", theme)),
                                          Expanded(flex: 1, child:sectionHeader("SEAT", theme)),
                                          Expanded(flex: 3, child:sectionHeader("PASSENGER NAME", theme)),
                                          Expanded(flex: 2, child:sectionHeader("SECTORS", theme)),
                                          Expanded(flex: 1, child:sectionHeader("BRD", theme)),
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
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.only(top: 100),
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

  Widget sectionHeader(String header, AppTheme theme) => 
      Text(
        header,
        textAlign: TextAlign.left,
        style:
            TextStyle(color: theme.flightListSectionHeaderColor, fontSize: 14),
      );

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
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: getTextValue((index+1).toString(), theme),
            ),
            Expanded(flex: 2, child: getTextValue('PNWJJD4', theme)),
            Expanded(flex: 1, child: getTextValue('7B', theme)),
            Expanded(flex: 3, child: getTextValue('**q', theme)),
            Expanded(flex: 2, child: getTextValue('BLR > DL', theme)),
            Expanded(flex: 1, child: getTextValue('d', theme)),
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

  Widget getTextValue(String title, AppTheme theme) {
    return Text(
      title,
      style: TextStyle(color: theme.flightInfoCardTextColor, fontSize: 16),
    );
  }



}

