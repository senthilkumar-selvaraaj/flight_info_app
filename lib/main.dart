import 'package:flight_info_app/blocs/login/login_bloc.dart';
import 'package:flight_info_app/models/lane.dart';
import 'package:flight_info_app/repos/auth_repository.dart';
import 'package:flight_info_app/screens/dashboard_screen.dart';
import 'package:flight_info_app/screens/lane_screen.dart';
import 'package:flight_info_app/screens/login_screen.dart';
import 'package:flight_info_app/services/socket_client.dart';
import 'package:flight_info_app/services/socket_notifier.dart';
import 'package:flight_info_app/utils/global_storage.dart';
import 'package:flight_info_app/utils/object_box.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late ObjectBox database;
List<Lane> allLanes = [];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.storage.load();
  database = await ObjectBox.create();
  allLanes = []; // database.store.box<Lane>().getAll();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1270, 768),
      size: Size(1270, 768),
      // fullScreen: true,
      center: true,
      title: 'AAI (Chennai)');
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (BuildContext context) {
            return ThemeNotifier();
          },
        ),
        ChangeNotifierProvider<SocketStatusNotifier>(
          create: (BuildContext context) {
            return SocketStatusNotifier();
          },
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     SocketClient().context = context;
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          scrollbarTheme: ScrollbarThemeData(
            interactive: true,
            radius: const Radius.circular(10.0),
            thumbColor: MaterialStateProperty.all(theme.flightBRDTextColor),
            trackColor: MaterialStateProperty.all(AppColors.black),
            trackBorderColor: MaterialStateProperty.all(AppColors.black),
            thickness: MaterialStateProperty.all(6.0),
            // minThumbLength: 50,
          ),
        ),
        navigatorKey: navigatorKey,
        title: 'AAI (Chennai)',
        home: MultiProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(AuthRepositary()),
            )
          ],
          child: allLanes.isEmpty
              ? const LaneScreen()
              :  const HomeScreen(),
        ));
  }
}
