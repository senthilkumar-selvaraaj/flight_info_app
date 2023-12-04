

import 'package:bloc/bloc.dart';
import 'package:flight_info_app/blocs/login/login_submission_state.dart';
import 'package:flight_info_app/repos/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepositary authRepo;
  
  LoginBloc(this.authRepo) : super(LoginState()) {
    on<LoginUsernameChanged>(_onUserNameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<PasswordEyeIconClicked>(_onPasswordEyeIconClicked);
  }
  void _onUserNameChanged(LoginUsernameChanged event, Emitter<LoginState> emit ){
      emit(state.copyWith(userName: event.userName));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit ){
      emit(state.copyWith(password: event.password));
  }
  void _onPasswordEyeIconClicked(PasswordEyeIconClicked event, Emitter<LoginState> emit ){
      emit(state.copyWith(visiblityStatus: !state.visiblityStatus));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit ) async{
      emit(state.copyWith(formStatus: FormSubmitting()));
      try{
        await authRepo.login(state.loginRequestJson);
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      }catch(e){
        emit(state.copyWith(formStatus: FormSubmissionFailure(e as Exception)));
        emit(state.copyWith(formStatus: const InitialFormStatus()));
      }

  }
}
