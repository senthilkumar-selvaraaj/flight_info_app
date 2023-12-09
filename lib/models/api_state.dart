enum APIRequestState{
  initial, loading, success, failure
}

abstract class RestAPIState{
  final APIRequestState state;
  final Exception? exception;
  const RestAPIState(this.state, this.exception);
}