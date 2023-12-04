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