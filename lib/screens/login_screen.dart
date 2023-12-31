import 'package:aai_chennai/blocs/login/login_bloc.dart';
import 'package:aai_chennai/blocs/login/login_submission_state.dart';
import 'package:aai_chennai/components/date_widget.dart';
import 'package:aai_chennai/components/login_view.dart';
import 'package:aai_chennai/components/snack_bar.dart';
import 'package:aai_chennai/components/status_icon_list.dart';
import 'package:aai_chennai/repos/auth_repository.dart';
import 'package:aai_chennai/screens/dashboard_screen.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
      body: BlocProvider(
        create: (context) => LoginBloc(AuthRepositary()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.formStatus is FormSubmissionSuccess) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DashboardScreen()));
            }
            if (state.formStatus is FormSubmissionFailure) {
              AppSnackBar.show(
                  context,
                  (state.formStatus as FormSubmissionFailure)
                      .exception
                      .toString());
            }
          },
          builder: (context, state) {
            return Container(
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
                              padding: EdgeInsets.only(top: 125, right: 150),
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
                    padding: EdgeInsets.only(
                        top: 40.0, bottom: 40, right: 70, left: 35),
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
            );
          },
        ),
      ),
    );
  }
}
