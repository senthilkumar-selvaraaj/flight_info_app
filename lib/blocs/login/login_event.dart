part of 'login_bloc.dart';

sealed class LoginEvent {
}

class LoginAgentNameChanged extends LoginEvent{
  LoginAgentNameChanged(this.agentName);

  final String agentName;
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

class LogoutSubmittedEvent extends LoginEvent{
  LogoutSubmittedEvent();
}
