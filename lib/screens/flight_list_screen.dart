import 'package:aai_chennai/blocs/flight_list/flight_list_bloc.dart';
import 'package:aai_chennai/components/footter.dart';
import 'package:aai_chennai/components/header.dart';
import 'package:aai_chennai/components/no_data_placeholder.dart';
import 'package:aai_chennai/models/api_state.dart';
import 'package:aai_chennai/models/flight_list.dart';
import 'package:aai_chennai/repos/floght_list_repository.dart';
import 'package:aai_chennai/screens/flight_boarding_screen.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:aai_chennai/utils/strings.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({super.key});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  int selectedFlightIndex = -1;
  FlightBoaringStatus boardingStatus = FlightBoaringStatus.none;
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            FlightListBloc(FlightListRepository())..add(FetchFlightListEvent()),
        child: BlocConsumer<FlightListBloc, FlightListState>(
          listener: (buildContext, state) {
            if (state.startBoardingState.state == APIRequestState.success) {
              Flight flight = state.flights[selectedFlightIndex];
              String startBoardCommand =
                  flight.getStartBoardCommand(state.sessionId);
                  if (context.mounted) {
                    setState(() {
                      boardingStatus = FlightBoaringStatus.none;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FlightBoardingScreen(
                            sessionId: state.sessionId,
                            flight: state.flights[selectedFlightIndex]))); 
                    });
                  }
              SocketClient().startBoardingCommand(startBoardCommand, (p0) {
                if (p0 == bsOK) {
                  
                } else {
                  if (context.mounted) {
                   // AppSnackBar.show(context, "Gate not ready");
                  }
                }
                
              });
              
            }
          },
          builder: (context, state) {
            return Padding(
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
                                  child: BlocBuilder<FlightListBloc,
                                      FlightListState>(
                                    builder: (context, state) {
                                      // if (state.flightListFetchingState.state ==
                                      //     APIRequestState.loading) {
                                      //   return Center(
                                      //       child: CircularProgressIndicator(
                                      //     color: theme.flightBRDTextColor,
                                      //   ));
                                      // }

                                      return Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "FLIGHT LIST",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: theme
                                                      .flightListHeaderColor),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    sectionHeader(
                                                        "FLIGHT", theme),
                                                    sectionHeader(
                                                        "FLIGHT STATUS", theme),
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
                                            Expanded(
                                                child: state.flightListFetchingState.state ==
                                          APIRequestState.loading ?   Center(
                                            child: Container(height: 50, width: 50, child:  CircularProgressIndicator(color: theme.flightBRDTextColor, ))) :  (state.flightListFetchingState.state ==
                                          APIRequestState.success && state.flights.isEmpty) ? const NoDataView() : getFlightList(
                                                    theme, context))
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 100),
                                    // color: AppColors.secondaryGrey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: Container(
                                            padding: const EdgeInsets.all(25),
                                            decoration: ShapeDecoration(
                                                color: theme
                                                    .flightInfoHintBannerBg,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )),
                                            child: Column(
                                              children: [
                                                Visibility(
                                                    visible: boardingStatus !=
                                                        FlightBoaringStatus
                                                            .none,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        boardingStatus
                                                            .getInfoTitle(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    )),
                                                Text(
                                                  boardingStatus
                                                      .getInfoDescription().replaceAll("##FLIGHTNO##",  selectedFlightIndex < 0 ? '' : '${BlocProvider.of<FlightListBloc>(
                                                                              context)
                                                                          .state
                                                                          .flights[selectedFlightIndex].iataCode}${BlocProvider.of<FlightListBloc>(
                                                                              context)
                                                                          .state
                                                                          .flights[selectedFlightIndex].flightNo}'),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 155,
                                              height: 45,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor: theme
                                                              .backgroundColor,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          side:
                                                              const BorderSide(
                                                            width: 2.0,
                                                            color: AppColors
                                                                .primaryBlue,
                                                          ),
                                                          shadowColor: Colors
                                                              .transparent),
                                                  onPressed: () {
                                                    switch (boardingStatus) {
                                                      case FlightBoaringStatus
                                                            .none:
                                                        Navigator.of(context)
                                                            .pop();
                                                      case FlightBoaringStatus
                                                            .confirm:
                                                        setState(() {
                                                          boardingStatus =
                                                              FlightBoaringStatus
                                                                  .none;
                                                        });
                                                      case FlightBoaringStatus
                                                            .boarding:
                                                        setState(() {
                                                          boardingStatus =
                                                              FlightBoaringStatus
                                                                  .none;
                                                        });
                                                    }
                                                  },
                                                  child: Text(
                                                    boardingStatus
                                                        .getBackButtonTitle(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: theme
                                                            .loginButtonBgColor),
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            selectedFlightIndex < 0 ? const SizedBox() : SizedBox(
                                              width: 155,
                                              height: 45,
                                              child: BlocBuilder<FlightListBloc,
                                                  FlightListState>(
                                                builder: (context, state) {
                                                  if (state.startBoardingState
                                                          .state ==
                                                      APIRequestState.loading) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: theme
                                                            .flightBRDTextColor,
                                                      ),
                                                    );
                                                  }
                                                  print(state.startBoardingState
                                                      .state);
                                                  return Visibility(visible: !(selectedFlightIndex < 0), child:  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          side: BorderSide(
                                                              width: 1.0,
                                                              color: theme
                                                                  .loginButtonBgColor),
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          backgroundColor: theme
                                                              .loginButtonBgColor),
                                                      onPressed: () {
                                                        /// SOCKET ===> \u0002BS\u0003SG\n1980\nMAA\nBLR\ne4496a4a-f8a6-4a1a-be7e-ed6cc1dafd87
                                                        /// BSOK
                                                        /// BSERR - Gate not ready - error message

                                                        if (selectedFlightIndex >
                                                            -1) {
                                                          switch (
                                                              boardingStatus) {
                                                            case FlightBoaringStatus
                                                                  .none:
                                                              setState(() {
                                                                boardingStatus =
                                                                    FlightBoaringStatus
                                                                        .confirm;
                                                              });
                                                            case FlightBoaringStatus
                                                                  .confirm:
                                                              setState(() {
                                                                boardingStatus =
                                                                    FlightBoaringStatus
                                                                        .boarding;
                                                              });
                                                            case FlightBoaringStatus
                                                                  .boarding:
                                                              BlocProvider.of<
                                                                          FlightListBloc>(
                                                                      context)
                                                                  .add(StartBoardingEvent(
                                                                      BlocProvider.of<FlightListBloc>(
                                                                              context)
                                                                          .state
                                                                          .flights[selectedFlightIndex]));
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        boardingStatus
                                                            .getConfirmButtonTitle(),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .white),
                                                      )));
                                                },
                                              ),
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
            );
          },
        ),
      ),
    );
  }

  Widget sectionHeader(String header, AppTheme theme) => Expanded(
      flex: 1,
      child: Text(
        header,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: theme.flightListSectionHeaderColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ));

  Widget getFlightList(AppTheme theme, BuildContext buildContext) {
    final flights = BlocProvider.of<FlightListBloc>(buildContext).state.flights;
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {},
        child: ListView.builder(
            controller: _controller,
            physics: boardingStatus == FlightBoaringStatus.none
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemCount: flights.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15, top: 7, bottom: 7),
                child: Focus(
                    canRequestFocus: boardingStatus == FlightBoaringStatus.none,
                    onFocusChange: (status) {},
                    child:
                        flightCard(flights[index], index, theme, context, () {
                      if (mounted) {
                        if (boardingStatus == FlightBoaringStatus.none) {
                          setState(() {
                            selectedFlightIndex = index;
                          });
                        }
                      }
                    })),
              );
            })));
  }

  void _scrollDown() {
    if (boardingStatus == FlightBoaringStatus.none &&
        selectedFlightIndex < 19) {
      setState(() {
        selectedFlightIndex += 1;
      });
    }
  }

  void _scrollUp() {
    _controller.animateTo(
      _controller.offset - 50.0, // Adjust the scroll distance as needed
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
  }

  Widget flightCard(Flight flight, int index, AppTheme theme,
      BuildContext context, Function() didSelected) {
    return GestureDetector(
      onTap: didSelected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
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
                  child: getFlightNo(
                      '${flight.iataCode}${flight.flightNo ?? ''}', theme),
                ),
                Expanded(flex: 1, child: getFlightStatus(flight, theme, index)),
                Expanded(
                    flex: 1,
                    child: getBRD(
                        DateFormat.Hm().format(flight.depDate!), index, theme)),
                Expanded(
                    flex: 1,
                    child: getDEP(
                        "${flight.origin} ${DateFormat.Hm().format(flight.depDate!)}",
                        theme)),
                Expanded(
                    flex: 1,
                    child: getARR(
                        "${flight.destination} ${DateFormat.Hm().format(flight.arrTime!)}",
                        theme)),
              ],
            ),
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

  Widget getFlightNo(String value, AppTheme theme) {
    return Text(
      //"SG198",
      value,
      style: TextStyle(
          color: theme.flightInfoCardTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500),
    );
  }

  Widget getFlightStatus(Flight flight, AppTheme theme, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Container(
        height: 46,
        width: 100,
        decoration: ShapeDecoration(
          color:
              getFlightStatusBackGroundColor(theme, flight.isDelayed ?? false),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            //"ONTIME",
            flight.statusMessage(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: getFlightStatusTextColor(
                    theme,
                    flight.isDelayed ?? false,
                    (Provider.of<ThemeNotifier>(context).isDark &&
                        selectedFlightIndex == index)),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Color getFlightStatusBackGroundColor(AppTheme theme, bool status) {
    if (status) {
      return theme.flightStatusDelayedBgColor;
    } else {
      return theme.flightStatusOnTimeBgColor;
    }
  }

  Color getFlightStatusTextColor(AppTheme theme, bool status, bool isSelected) {
    if (status) {
      return isSelected ? AppColors.white : theme.flightStatusDelayedTextColor;
    } else {
      return isSelected ? AppColors.white : theme.flightStatusOntTmeTextColor;
    }
  }

  Widget getBRD(String value, int index, AppTheme theme) {
    return Text(
      // "13:50",
      value,
      style: TextStyle(
          color: (Provider.of<ThemeNotifier>(context).isDark &&
                  selectedFlightIndex == index)
              ? AppColors.white
              : theme.flightBRDTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600),
    );
  }

  Widget getDEP(String value, AppTheme theme) {
    return Text(
      //"BLR 14:00",
      value,
      style: TextStyle(
          color: theme.flightInfoCardTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500),
    );
  }

  Widget getARR(String value, AppTheme theme) {
    return Text(
      //"MMA 20:20",
      value,
      style: TextStyle(
          color: theme.flightInfoCardTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500),
    );
  }
}

enum FlightStatus { ontime, delayed }

enum FlightBoaringStatus {
  none,
  confirm,
  boarding;

  String getConfirmButtonTitle() {
    switch (this) {
      case FlightBoaringStatus.none:
        return "Open Flight";
      case FlightBoaringStatus.confirm:
        return "Confirm";
      case FlightBoaringStatus.boarding:
        return "Start Boarding";
    }
  }

  String getBackButtonTitle() {
    switch (this) {
      case FlightBoaringStatus.none:
        return "Back";
      case FlightBoaringStatus.confirm:
        return "Cancel";
      case FlightBoaringStatus.boarding:
        return "Cancel";
    }
  }

  String getInfoTitle() {
    switch (this) {
      case FlightBoaringStatus.none:
        return "";
      case FlightBoaringStatus.confirm:
        return "Confirm Flight";
      case FlightBoaringStatus.boarding:
        return "Ready to Board";
    }
  }

  String getInfoDescription() {
    switch (this) {
      case FlightBoaringStatus.none:
        return "Select a flight from the list then choose 'Open Flight' when ready";
      case FlightBoaringStatus.confirm:
        return "The gate will close automatically after confirmation. Please ensure the gate area is clear of any objects of persons before proceeding";
      case FlightBoaringStatus.boarding:
        return "E-Gate is now ready to board flight ##FLIGHTNO##. Select 'Start Boarding' to begin boarding";
    }
  }
}
