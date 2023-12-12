import 'package:flight_info_app/blocs/flight_boarding/flight_boarding_bloc.dart';
import 'package:flight_info_app/components/app_buttons.dart';
import 'package:flight_info_app/components/app_text_field.dart';
import 'package:flight_info_app/components/dialogs.dart';
import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/models/api_state.dart';
import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/models/pxt_list.dart';
import 'package:flight_info_app/repos/flight_boarding.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FlightBoardingScreen extends StatefulWidget {
  final String sessionId;
  final Flight flight;
  const FlightBoardingScreen(
      {super.key, required this.flight, required this.sessionId});

  @override
  State<FlightBoardingScreen> createState() => _FlightBoardingScreenState();
}

class _FlightBoardingScreenState extends State<FlightBoardingScreen> {
  final ScrollController _controller = ScrollController();
  final _focusNode = FocusNode();
  final doc = pw.Document();

  @override
  void initState() {
    super.initState();
  }

  void onSearchTextChanged(BuildContext context, String? keyword) {
    BlocProvider.of<FlightBoardingBloc>(context)
        .add(SearchtextChangedEvent(keyword ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return BlocProvider(
      create: (context) => FlightBoardingBloc(FlightBoardingRepository())
        ..add(UpdateFlightInfoEvent(widget.flight))
        ..add(UpdateSessionIdEvent(widget.sessionId))
        ..add(const FetchPaxListEvent()),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: BlocListener<FlightBoardingBloc, FlightBoardingState>(
          listener: (context, state) {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 75),
            child: Column(
              children: [
                const Header(),
                BlocBuilder<FlightBoardingBloc, FlightBoardingState>(
                  builder: (context, state) {
                    if (state.paxListFetchingState.state ==
                        APIRequestState.loading) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: theme.flightBRDTextColor,
                      ));
                    }
                    return Expanded(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    color: theme
                                                        .flightListHeaderColor),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18),
                                                child: Row(
                                                  children: [
                                                    const Focus(
                                                        descendantsAreFocusable:
                                                            false,
                                                        canRequestFocus: false,
                                                        child: InfoIcon()),
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: SizedBox(
                                                                  height: 40,
                                                                  child:
                                                                      SearchFromField(
                                                                    hintText:
                                                                        "Search",
                                                                    onChanged:
                                                                        (k) {
                                                                      onSearchTextChanged(
                                                                          context,
                                                                          k);
                                                                    },
                                                                  ))),
                                                          Icon(
                                                            CupertinoIcons
                                                                .search,
                                                            color: theme
                                                                .flightBRDTextColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: sectionHeader(
                                                          "SEQ", theme)),
                                                  Expanded(
                                                      flex: 2,
                                                      child: sectionHeader(
                                                          "PNR", theme)),
                                                  Expanded(
                                                      flex: 1,
                                                      child: sectionHeader(
                                                          "SEAT", theme)),
                                                  Expanded(
                                                      flex: 3,
                                                      child: sectionHeader(
                                                          "PASSENGER NAME",
                                                          theme)),
                                                  Expanded(
                                                      flex: 2,
                                                      child: sectionHeader(
                                                          "SECTORS", theme)),
                                                  Expanded(
                                                      flex: 1,
                                                      child: sectionHeader(
                                                          "BRD", theme)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                              child: getPaxList(
                                                  BlocProvider.of<
                                                              FlightBoardingBloc>(
                                                          context)
                                                      .state
                                                      .paxes,
                                                  theme)),
                                          Visibility(
                                              visible: BlocProvider.of<
                                                              FlightBoardingBloc>(
                                                          context)
                                                      .state
                                                      .pax !=
                                                  null,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                                child: Text(
                                                  BlocProvider.of<FlightBoardingBloc>(
                                                              context)
                                                          .state
                                                          .pax
                                                          ?.description() ??
                                                      '',
                                                  style: TextStyle(
                                                      color: theme
                                                          .flightInfoCardTextColor),
                                                ),
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: SizedBox(
                                              height: 42,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        BlocProvider.of<FlightBoardingBloc>(
                                                                        context)
                                                                    .state
                                                                    .pax !=
                                                                null
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  BlocBuilder<
                                                                      FlightBoardingBloc,
                                                                      FlightBoardingState>(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                      if (state.paxOnBoardingState.state ==
                                                                              APIRequestState
                                                                                  .loading ||
                                                                          state.paxDeBoardingState.state ==
                                                                              APIRequestState.loading) {
                                                                        return CircularProgressIndicator(
                                                                          color:
                                                                              theme.flightBRDTextColor,
                                                                        );
                                                                      }

                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                15),
                                                                        child: FilledActionButton(
                                                                            title: BlocProvider.of<FlightBoardingBloc>(context).state.pax?.paxButtonTitle() ?? '',
                                                                            height: 42,
                                                                            width: 150,
                                                                            didTapped: () {
                                                                              if (BlocProvider.of<FlightBoardingBloc>(context).state.pax?.status != null && BlocProvider.of<FlightBoardingBloc>(context).state.pax?.status == 'B') {
                                                                                BlocProvider.of<FlightBoardingBloc>(context).add(const DeBoardingPaxEvent());
                                                                              } else {
                                                                                BlocProvider.of<FlightBoardingBloc>(context).add(const BoardingPaxEvent());
                                                                              }
                                                                            }),
                                                                      );
                                                                    },
                                                                  ),
                                                                  Visibility(
                                                                      visible: (BlocProvider.of<FlightBoardingBloc>(context)
                                                                              .state
                                                                              .pax
                                                                              ?.showManifest() ??
                                                                          false),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                15),
                                                                        child: BorderedActionButton(
                                                                            title: 'Print Manifest',
                                                                            height: 42,
                                                                            width: 150,
                                                                            didTapped: () {
                                                                              doc.addPage(pw.Page(
                                                                                  pageFormat: PdfPageFormat.a4,
                                                                                  build: (pw.Context context) {
                                                                                    return pw.Center(
                                                                                      child: pw.Text('Hello World'),
                                                                                    ); // Center
                                                                                  }));
                                                                            }),
                                                                      )),
                                                                  BorderedActionButton(
                                                                      title:
                                                                          'Print ATB',
                                                                      height:
                                                                          42,
                                                                      width:
                                                                          150,
                                                                      didTapped:
                                                                          () {})
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: Container(
                                                      height: 40,
                                                      width: 275,
                                                      decoration: ShapeDecoration(
                                                          color: theme
                                                              .boardingInfoContainerColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                      child:  Center(
                                                          child: Text(
                                                        "${BlocProvider.of<FlightBoardingBloc>(context).state.getBoadringInfo()}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: AppColors
                                                                .white),
                                                      )),
                                                    ),
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
                    );
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                const Footter()
              ],
            ),
          ),
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
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: SizedBox(
                    height: 48,
                    width: 312,
                    child: Stack(
                      children: [
                        Image(
                            image: AssetImage(
                                'assets/images/bg-shape-${Provider.of<ThemeNotifier>(context).isDark ? 'dark' : 'light'}.png'),
                            fit: BoxFit.fill),
                        Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Text(widget.flight.flightNo ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: theme.flightListHeaderColor))),
                            Expanded(
                                child: Text(
                              "${widget.flight.origin ?? ''}\n${widget.flight.getDepartureTime()}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white),
                            )),
                            Expanded(
                                child: Text(
                                    "${widget.flight.destination ?? ''}\n${widget.flight.getArrivalTime()}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white))),
                          ],
                        )),
                      ],
                    )),
              ),
              const SizedBox(
                height: 25,
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
                height: 30,
              ),
              Expanded(
                  child: RawScrollbar(
                      thumbColor: Colors.redAccent,
                      radius: const Radius.circular(20),
                      thickness: 5,
                      child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 120,
                                  decoration:
                                      getLaneShadowShape(theme, context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 9.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Lane ${(index + 1).toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            color: theme.laneTitleColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Text("Boarded",
                                                style: TextStyle(
                                                    color: theme
                                                        .laneBoardingTitleColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Text("07/7E/qq",
                                                style: TextStyle(
                                                  color: theme
                                                      .laneBoardingValueColor,
                                                  fontSize: 16,
                                                ))
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ))))
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

  Widget getPaxList(List<Pax> paxList, AppTheme theme) {
    return RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (RawKeyEvent event) {},
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _controller,
            itemCount: paxList.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15, top: 7, bottom: 7),
                child: Focus(
                    child:
                        flightCard(index, paxList[index], theme, context, () {
                  if (mounted) {
                    _focusNode.requestFocus();
                    BlocProvider.of<FlightBoardingBloc>(context)
                        .add(UpdateSelectedPaxEvent(paxList[index]));
                  }
                })),
              );
            })));
  }

  Widget flightCard(int index, Pax pax, AppTheme theme, BuildContext context,
      Function() didSelected) {
    bool isSelected = (pax.seqNo ==
        BlocProvider.of<FlightBoardingBloc>(context).state.pax?.seqNo);
    return GestureDetector(
        onTap: didSelected,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: getShadowShape(isSelected, theme, context),
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: getTextValue(pax.seqNo ?? '', theme),
                  ),
                  Expanded(flex: 2, child: getTextValue(pax.pnr ?? '', theme)),
                  Expanded(
                      flex: 1, child: getTextValue(pax.seatNo ?? '', theme)),
                  Expanded(flex: 3, child: getTextValue(pax.getName(), theme)),
                  Expanded(
                      flex: 2,
                      child: getTextValue(
                          '${pax.origin} > ${pax.destination}', theme)),
                  Expanded(flex: 1, child: getPaxBoardingStatus(pax, theme)),
                ],
              ),
            ),
          ),
        ));
  }

  ShapeDecoration getShadowShape(
      bool isSelected, AppTheme theme, BuildContext context) {
    return ShapeDecoration(
      color: (Provider.of<ThemeNotifier>(context).isDark && isSelected)
          ? AppColors.primaryBlue
          : theme.flightInfoCardBgColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: (!Provider.of<ThemeNotifier>(context).isDark && isSelected)
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

  ShapeDecoration getLaneShadowShape(AppTheme theme, BuildContext context) {
    return ShapeDecoration(
      color: theme.flightInfoCardBgColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.transparent, width: 2.0),
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

  Widget getPaxBoardingStatus(Pax pax, AppTheme theme) {
    Color c = Provider.of<ThemeNotifier>(context).isDark
        ? Colors.white
        : Colors.green;
    if (pax.status != null) {
      return pax.status == 'B'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('assets/icons/tick.png'),
                  color: c,
                )
              ],
            )
          : getDelayedStatus('d', theme);
    }

    return const SizedBox();
  }

  Widget getDelayedStatus(String title, AppTheme theme) {
    return Text(title,
        style: TextStyle(
            color: theme.flightInfoCardTextColor,
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold));
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
              bodyBuilder: (context) => const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: Text(
                              "*",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )),
                        Text("SSR PAX",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: Text("**",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                        Text("PAX WITH INFANT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: Text("+",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                        Text("WHEELCHAIR PAX",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                      ],
                    )
                  ],
                ),
              ),
              onPop: () => print('Popover was popped!'),
              direction: PopoverDirection.bottom,
              transition: PopoverTransition.other,
              width: 200,
              height: 100,
              arrowHeight: 15,
              arrowWidth: 30,
            );
          },
          icon: Icon(
            Icons.info,
            color: theme.flightBRDTextColor,
            size: 32,
          )),
    );
  }
}
