import 'dart:io';

import 'package:flight_info_app/blocs/login/login_bloc.dart';
import 'package:flight_info_app/components/dialogs.dart';
import 'package:flight_info_app/components/footter.dart';
import 'package:flight_info_app/components/header.dart';
import 'package:flight_info_app/components/menu_card.dart';
import 'package:flight_info_app/components/menu_list.dart';
import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/models/api_state.dart';
import 'package:flight_info_app/models/lane.dart';
import 'package:flight_info_app/repos/auth_repository.dart';
import 'package:flight_info_app/screens/flight_list_screen.dart';
import 'package:flight_info_app/screens/login_screen.dart';
import 'package:flight_info_app/services/socket_client.dart';
import 'package:flight_info_app/utils/global_storage.dart';
import 'package:flight_info_app/utils/themes.dart';
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
    // connectSocket();
    SocketClient().connect();
  }

  void connectSocket() async{
    print("SVvv");
    // Define the server's IP address and port
  final String serverIp = '3.111.72.224'; // Change to the server's IP address
  final int serverPort = 2100; // Change to the server's port

  try {
    // Create a socket connection to the server
    final socket = await Socket.connect(serverIp, serverPort, timeout: const Duration(seconds: 30));

    // Send data to the server
    // socket.writeln('Hello, server!');
    // Listen for data from the server

    // socket.writeln("\u0002LN\u000362638e4b0e43012248aab387\n");

    socket.listen(
      (data) {
        print('Received from server: ${String.fromCharCodes(data)}');
      },
      onDone: () {
        print('Server disconnected.');
          socket.writeln("\u0002LN\u000362638e4b0e43012248aab387\n");
        socket.destroy();
      },
      onError: (error) {
        print('Error: $error');
        socket.destroy();
      },
    );


    // Close the socket when you're done
    // socket.close();
  } catch (e) {
    print('Error: $e');
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
