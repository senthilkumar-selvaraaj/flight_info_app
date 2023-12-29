part of 'login_bloc.dart';


 class LoginState {
   final String agentName;
  final String userName;
  final String password;
  final FormSubmissionStatus formStatus;
  final LogOutSubmissionState logoutSubmissionState;
  final bool visiblityStatus;

  bool get isValidUserName => true;
  bool get isValidPassword => password.length > 3;
  bool get obscuredText => visiblityStatus;

   LoginState({
      this.agentName ='',
      this.userName = '',
      this.password = '',
      this.logoutSubmissionState = const LogOutSubmissionState(APIRequestState.initial, null),
      this.formStatus =  const InitialFormStatus(),
      this.visiblityStatus = true
    });

   LoginState copyWith({
     String? agentName,
     String? userName,
     String? password,
     FormSubmissionStatus? formStatus,
    LogOutSubmissionState? logoutSubmissionState,
    bool? visiblityStatus}){
      return LoginState(
        agentName: agentName ?? this.agentName,
        userName: userName ?? this.userName, 
        password: password ?? this.password, 
        formStatus: formStatus ?? this.formStatus,
        logoutSubmissionState: logoutSubmissionState ?? this.logoutSubmissionState,
        visiblityStatus: visiblityStatus ?? this.visiblityStatus
        );
   }

  Map<String, String> get loginRequestJson{
    return {
        'agent_name': agentName,
        'username':userName,
        'password':password
    };
  }

  Map<String, String> get logoutRequestJson{
     return {"refresh_token": Global.storage.refreshToken ?? ""};
  }

 

}
