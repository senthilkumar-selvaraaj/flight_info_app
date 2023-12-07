enum APIRequestState{
  initial, loading, sucess, faulure
}

abstract class RestAPIState{
  final APIRequestState state;
  final Exception? exception;
  const RestAPIState(this.state, this.exception);
}