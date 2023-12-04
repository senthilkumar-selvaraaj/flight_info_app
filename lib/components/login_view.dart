import 'package:flight_info_app/blocs/login/login_bloc.dart';
import 'package:flight_info_app/components/app_text_field.dart';
import 'package:flight_info_app/screens/dashboard_screen.dart';
import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
 @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          textAlign: TextAlign.left,
          style: TextStyle(color: theme.loginHeaderColor, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 15,
        ),
        Text("Welcome, Please login to your account",
            textAlign: TextAlign.left,
            style: TextStyle(color: theme.welcomeMessageColor, fontSize: 18)),
        const SizedBox(
          height: 50,
        ),
        Container(
          height: 164,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: theme.loginContainerBorderColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: getUserNameTextField(),
              ),
              SizedBox(
                height: 2,
                child: Divider(
                  color: theme.loginContainerBorderColor,
                ),
              ),
              Expanded(child: getPasswordTextField())
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  backgroundColor: theme.loginButtonBgColor),
              onPressed: () {
                //navigateToDashBoard();
                BlocProvider.of<LoginBloc>(context).add(LoginSubmitted());
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20, color: AppColors.white, fontWeight: FontWeight.w500),
              )),
        )
      ],
    );
  }

  Widget getUserNameTextField() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          // textFieldLabel("Username"),
          AppTextField(
            label: "Username",
            onChanged: (p0) {
              BlocProvider.of<LoginBloc>(context).add(LoginUsernameChanged(p0 ?? ''));
            },
          ),
        ],
      ),
    );
  }

  Widget getPasswordTextField() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          // textFieldLabel('Password'),
          AppTextField(
            label: "Password",
            isSecured: true,
            onChanged: (p0) {
              BlocProvider.of<LoginBloc>(context).add(LoginPasswordChanged(p0 ?? ''));
            },
          ),
        ],
      ),
    );
  }

  Widget textFieldLabel(String text) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        text,
        style: TextStyle(color: theme.placeholderColor, fontSize: 14),
      ),
    );
  }

  navigateToDashBoard() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DashboardScreen()));
  }
}
