part of 'login_bloc.dart';

sealed class LoginEvent {
}

class LoginUsernameChanged extends LoginEvent{
  LoginUsernameChanged(this.userName);

  final String userName;
}

 class LoginPasswordChanged extends LoginEvent{
  LoginPasswordChanged(this.password);

  final String password;
}

 class LoginSubmitted extends LoginEvent{
   LoginSubmitted();
}

class PasswordEyeIconClicked extends LoginEvent{
   PasswordEyeIconClicked();
}
