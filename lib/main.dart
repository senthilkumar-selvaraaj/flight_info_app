
import 'package:flight_info_app/screens/login_screen.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true,
    minimumSize: Size(1260, 768),
    center: true,
    title: 'AAI (Chennai)'
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(ChangeNotifierProvider(create: (context)=>ThemeNotifier(), child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat',
        scrollbarTheme:  ScrollbarThemeData(
  interactive: true,
  // thumbVisibility: MaterialStateProperty.all(true),
  radius: const Radius.circular(10.0),
  thumbColor: MaterialStateProperty.all(theme.flightBRDTextColor),
  trackColor: MaterialStateProperty.all(AppColors.black) ,
  trackBorderColor: MaterialStateProperty.all(AppColors.black) ,
  thickness: MaterialStateProperty.all(6.0),
  // minThumbLength: 50,
),

        ),
        title: 'Airport Authority of India',
        home: const HomeScreen());
  }
}
