import 'package:flight_info_app/components/date_widget.dart';
import 'package:flight_info_app/components/login_view.dart';
import 'package:flight_info_app/components/status_icon_list.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      body: Container(
        color: theme.backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: const Image(
                        image: AssetImage('assets/images/login-bg.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Positioned.fill(
                        child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 125, right: 100),
                        child: Image(
                          image: AssetImage('assets/images/logo-cia.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 40, right: 70, left: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DateTimeHolder(),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [LoginView()],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StatusList(),
                    ],
                  ),
                ],
              ),
            )),
            // const SizedBox(height: 70, child: StatusList(),),
          ],
        ),
      ),
    );
  }
}
