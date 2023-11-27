import 'package:flight_info_app/components/app_buttons.dart';
import 'package:flight_info_app/components/app_text_field.dart';
import 'package:flight_info_app/components/dialogs.dart';
import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class FlightBoardingScreen extends StatefulWidget {
  const FlightBoardingScreen({super.key});

  @override
  State<FlightBoardingScreen> createState() => _FlightBoardingScreenState();
}

class _FlightBoardingScreenState extends State<FlightBoardingScreen> {
  int selectedFlightIndex = -1;
  final ScrollController _controller = ScrollController();
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 75),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "FLIGHT MANIFEST",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: theme.flightListHeaderColor),
                                      ),
                                      Row(
                                        children: [
                                         Focus(
                                          descendantsAreFocusable: false,
                                          canRequestFocus: false,
                                          child:  InfoIcon()),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Container(
                                            width: 300,
                                            height: 40,
                                            decoration: ShapeDecoration(
                                                color: theme
                                                    .dateTimeBackgroundColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: SizedBox(
                                                        height: 40,
                                                        child: SearchFromField(
                                                          hintText: "Search",
                                                          onChanged: (s) {},
                                                        ))),
                                                const Image(
                                                    image: AssetImage(
                                                        'assets/icons/search.png')),
                                                const SizedBox(
                                                  width: 15,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
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
                                          Expanded(
                                              flex: 1,
                                              child:
                                                  sectionHeader("SEQ", theme)),
                                          Expanded(
                                              flex: 2,
                                              child:
                                                  sectionHeader("PNR", theme)),
                                          Expanded(
                                              flex: 1,
                                              child:
                                                  sectionHeader("SEAT", theme)),
                                          Expanded(
                                              flex: 3,
                                              child: sectionHeader(
                                                  "PASSENGER NAME", theme)),
                                          Expanded(
                                              flex: 2,
                                              child: sectionHeader(
                                                  "SECTORS", theme)),
                                          Expanded(
                                              flex: 1,
                                              child:
                                                  sectionHeader("BRD", theme)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(child: getFlightList(theme)),
                                  Visibility(
                                      visible: selectedFlightIndex > -1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 5),
                                        child: Text(
                                          "Selected: 1 | HJHHS65 | 7B | MR qq | BLR > DL",
                                          style: TextStyle(
                                              color: theme
                                                  .flightInfoCardTextColor),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SizedBox(
                                      height: 42,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: selectedFlightIndex > -1
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15),
                                                        child:
                                                            FilledActionButton(
                                                                title:
                                                                    'Board PAX',
                                                                height: 42,
                                                                width: 150,
                                                                didTapped:
                                                                    () {}),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 15),
                                                        child:
                                                            BorderedActionButton(
                                                                title:
                                                                    'Print Manifest',
                                                                height: 42,
                                                                width: 150,
                                                                didTapped:
                                                                    () async {
                                                                  await showPopover(
                                                                    context:
                                                                        context,
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .black,
                                                                    // barrierDismissible: false,
                                                                    bodyBuilder:
                                                                        (context) =>
                                                                            Center(
                                                                                child: Text(
                                                                      "Switch to ${Provider.of<ThemeNotifier>(context).isDark ? 'Light' : 'Dark'} Mode",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              AppColors.white),
                                                                    )),
                                                                    onPop: () =>
                                                                        print(
                                                                            'Popover was popped!'),
                                                                    direction:
                                                                        PopoverDirection
                                                                            .bottom,

                                                                    width: 160,
                                                                    height: 42,
                                                                    arrowHeight:
                                                                        10,
                                                                    arrowWidth:
                                                                        20,
                                                                    transition:
                                                                        PopoverTransition
                                                                            .scale,
                                                                  );
                                                                }),
                                                      ),
                                                      BorderedActionButton(
                                                          title: 'Print ATB',
                                                          height: 42,
                                                          width: 150,
                                                          didTapped: () {})
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 275,
                                            decoration: ShapeDecoration(
                                                color: theme
                                                    .boardingInfoContainerColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            child: const Center(
                                                child: Text(
                                              "3/30  YTB=(25   -   INFT  0/0)",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: AppColors.white),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        rigthContainer(theme)
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

  Expanded rigthContainer(AppTheme theme) {
    return Expanded(
        flex: 4,
        child: Container(
          // color: Colors.amber,
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text("FLIGHT DETAILS",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: theme.flightListHeaderColor)),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 47,
                  child: Stack(
                    children: [
                      Image(
                          image: AssetImage(
                              'assets/images/bg-shape-${Provider.of<ThemeNotifier>(context).isDark ? 'dark' : 'light'}.png')),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text("SG6544",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: theme.flightListHeaderColor))),
                          const Expanded(
                              child: Text(
                            "BLR\n0140",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          )),
                          const Expanded(
                              child: Text("DELHJS\n0435",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white))),
                        ],
                      )),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(),
                  FilledActionButton(
                    title: 'End Boarding',
                    didTapped: () {
                      Dialogs.showAlertDialog(
                          context, DialogType.endBoarding, theme, () {}, () {
                        Navigator.of(context).pop();
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 120,
                              decoration: getShadowShape(-2, theme, context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'Lane $index',
                                      style: TextStyle(
                                        color: theme.laneTitleColor,
                                        fontSize: 16,
                                      ),
                                    )),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Text("Boarded",
                                            style: TextStyle(
                                                color: theme
                                                    .laneBoardingTitleColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text("07/7E/qq",
                                            style: TextStyle(
                                              color:
                                                  theme.laneBoardingValueColor,
                                              fontSize: 16,
                                            ))
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          )))
            ],
          ),
        ));
  }

  Widget sectionHeader(String header, AppTheme theme) => Text(
        header,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: theme.flightListSectionHeaderColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      );

  Widget getFlightList(AppTheme theme) {
    return RawKeyboardListener(focusNode: _focusNode,
    autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _scrollDown();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _scrollUp();
          }
        }
      },
     child: ListView.builder(
      // primary: true,
      scrollDirection: Axis.vertical,
      controller: _controller,
        itemCount: 20,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15, top: 7, bottom: 7),
            child: flightCard(index, theme, context, () {
              if (mounted) {
                _focusNode.requestFocus();
                setState(() {
                  selectedFlightIndex = index;
                });
              }
              
            }),
          );
        })));
  }


  void _scrollDown() {
    _controller.animateTo(
      _controller.offset + 50.0, // Adjust the scroll distance as needed
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
    _focusNode.requestFocus();
  }

  void _scrollUp() {
    _controller.animateTo(
      _controller.offset - 50.0, // Adjust the scroll distance as needed
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
    _focusNode.requestFocus();
  }


  Widget flightCard(
      int index, AppTheme theme, BuildContext context, Function() didSelected) {
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
                child: getTextValue((index + 1).toString(), theme),
              ),
              Expanded(flex: 2, child: getTextValue('PNWJJD4', theme)),
              Expanded(flex: 1, child: getTextValue('7B', theme)),
              Expanded(flex: 3, child: getTextValue('**q', theme)),
              Expanded(flex: 2, child: getTextValue('BLR > DL', theme)),
              Expanded(flex: 1, child: getTextValue('d', theme)),
            ],
          ),
        ),
      ),
    );
  }

  ShapeDecoration getShadowShape(
      int index, AppTheme theme, BuildContext context) {
    return ShapeDecoration(
      color: (Provider.of<ThemeNotifier>(context).isDark &&
              selectedFlightIndex == index)
          ? AppColors.primaryBlue
          : theme.flightInfoCardBgColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: (!Provider.of<ThemeNotifier>(context).isDark &&
                    selectedFlightIndex == index)
                ? AppColors.primaryBlue
                : Colors.transparent,
            width: 2.0),
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
      style: TextStyle(
          color: theme.flightInfoCardTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500),
    );
  }
}

class InfoIcon extends StatelessWidget {
  const InfoIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Container(
      child: IconButton(
        
          onPressed: () {
            showPopover(
              backgroundColor: theme.popOverBackgroundColor,
              context: context,
              barrierColor: Colors.transparent,
              bodyBuilder: (context) =>
                 const Padding(
                   padding:  EdgeInsets.all(10.0),
                   child: Column(children: [
                   Row(children: [SizedBox(width: 30, child: Text("*", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)), Text("SSR PAX", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))],),
                   SizedBox(height: 10,),
                   Row(children: [SizedBox(width: 30, child: Text("**", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),Text("PAX WITH INFANT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))],),
                   SizedBox(height: 10,),
                   Row(children: [SizedBox(width: 30, child: Text("+", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))), Text("WHEELCHAIR PAX", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))],)
                   ],),
                 ),
              onPop: () => print(
                  'Popover was popped!'),
              direction:
                  PopoverDirection.bottom,
                  transition: PopoverTransition.other,
              width: 200,
              height: 100,
              arrowHeight: 15,
              arrowWidth: 30,
            );
          },
          icon: const Image(
            image: AssetImage(
                'assets/icons/info.png'),
          )),
    );
  }
}
