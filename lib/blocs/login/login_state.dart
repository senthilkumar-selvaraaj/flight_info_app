part of 'login_bloc.dart';


 class LoginState {
  final String userName;
  final String password;
  final FormSubmissionStatus formStatus;
  final bool visiblityStatus;

  bool get isValidUserName => true;
  bool get isValidPassword => password.length > 3;
  bool get obscuredText => visiblityStatus;

   LoginState({
      this.userName = '',
      this.password = '',
      this.formStatus =  const InitialFormStatus(),
      this.visiblityStatus = true
    });

   LoginState copyWith({
     String? userName,
     String? password,
     FormSubmissionStatus? formStatus,
    bool? visiblityStatus}){
      return LoginState(
        userName: userName ?? this.userName, 
        password: password ?? this.password, 
        formStatus: formStatus ?? this.formStatus,
        visiblityStatus: visiblityStatus ?? this.visiblityStatus
        );
   }

  Map<String, String> get loginRequestJson{
    return {
        'username':userName,
        'password':password
    };
  }

}
