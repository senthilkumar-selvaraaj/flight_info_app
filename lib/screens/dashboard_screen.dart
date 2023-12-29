import 'dart:io';

import 'package:aai_chennai/blocs/login/login_bloc.dart';
import 'package:aai_chennai/components/dialogs.dart';
import 'package:aai_chennai/components/footter.dart';
import 'package:aai_chennai/components/header.dart';
import 'package:aai_chennai/components/menu_card.dart';
import 'package:aai_chennai/components/menu_list.dart';
import 'package:aai_chennai/main.dart';
import 'package:aai_chennai/models/api_state.dart';
import 'package:aai_chennai/models/lane.dart';
import 'package:aai_chennai/repos/auth_repository.dart';
import 'package:aai_chennai/screens/flight_list_screen.dart';
import 'package:aai_chennai/screens/login_screen.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:aai_chennai/utils/global_storage.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

@override
  void initState() {
    super.initState();
    if(!SocketClient().isConnected){
         SocketClient().connect();
    }
  }


  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: BlocProvider(
        create: (context) => LoginBloc(AuthRepositary()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (buildContext, state) async {
            if (state.logoutSubmissionState.state == APIRequestState.success) {
              await Global.storage.logOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              }
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (buildContext, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 35, horizontal: 75),
                child: Column(
                  children: [
                    const Header(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(125),
                        child: MenuList(
                          didSelected: (menu) {
                            if (menu == Menu.flightList) {
                              navigateToFlightListScreen();
                            } else if (menu == Menu.logOut) {
                              Dialogs.showAlertDialog(
                                  context, DialogType.logout, theme, () {},
                                  () async {
                                BlocProvider.of<LoginBloc>(buildContext)
                                    .add(LogoutSubmittedEvent());
                              });
                            } else if (menu == Menu.exit) {
                              Dialogs.showAlertDialog(
                                  context, DialogType.exit, theme, () {}, () {
                                exit(0);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const Footter()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  navigateToFlightListScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const FlightListScreen(),
    ));
  }
}
