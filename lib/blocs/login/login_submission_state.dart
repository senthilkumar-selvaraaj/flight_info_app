import 'package:flight_info_app/models/api_state.dart';

abstract class FormSubmissionStatus{
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus{
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus{
}

class FormSubmissionSuccess extends FormSubmissionStatus{}

class FormSubmissionFailure extends FormSubmissionStatus{
  final Exception exception;
  FormSubmissionFailure(this.exception);
}


class LogOutSubmissionState extends RestAPIState{
  const LogOutSubmissionState(super.state, super.exception);
}