

import 'package:aai_chennai/main.dart';
import 'package:bloc/bloc.dart';
import 'package:aai_chennai/blocs/login/login_submission_state.dart';
import 'package:aai_chennai/models/api_state.dart';
import 'package:aai_chennai/repos/auth_repository.dart';
import 'package:aai_chennai/utils/global_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepositary authRepo;
  
  LoginBloc(this.authRepo) : super(LoginState()) {
    on<LoginUsernameChanged>(_onUserNameChanged);
    on<LoginAgentNameChanged>(_onAgentNameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<PasswordEyeIconClicked>(_onPasswordEyeIconClicked);
    on<LogoutSubmittedEvent>(_onLogOutSubmitted);
  }

  void _onAgentNameChanged(LoginAgentNameChanged event, Emitter<LoginState> emit ){
      emit(state.copyWith(agentName: event.agentName));
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

  Future<void> _onLogOutSubmitted(LogoutSubmittedEvent event, Emitter<LoginState> emit ) async{
      emit(state.copyWith(logoutSubmissionState: const LogOutSubmissionState(APIRequestState.loading, null)));
      try{
        await authRepo.logout(state.loginRequestJson);
        emit(state.copyWith(logoutSubmissionState: const LogOutSubmissionState(APIRequestState.success, null)));
      }catch(e){
        emit(state.copyWith(logoutSubmissionState: const LogOutSubmissionState(APIRequestState.failure, null)));
        emit(state.copyWith(logoutSubmissionState: const LogOutSubmissionState(APIRequestState.initial, null)));
      }

  }
}
