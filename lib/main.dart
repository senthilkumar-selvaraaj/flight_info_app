import 'package:aai_chennai/blocs/login/login_bloc.dart';
import 'package:aai_chennai/models/lane.dart';
import 'package:aai_chennai/repos/auth_repository.dart';
import 'package:aai_chennai/screens/lane_screen.dart';
import 'package:aai_chennai/screens/login_screen.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:aai_chennai/services/socket_notifier.dart';
import 'package:aai_chennai/utils/object_box.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late ObjectBox database;
List<Lane> allLanes = [];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Global.storage.load();
  database = await ObjectBox.create();
  allLanes = database.store.box<Lane>().getAll();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1270, 768),
      fullScreen: true,
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
