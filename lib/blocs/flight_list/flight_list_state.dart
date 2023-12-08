part of 'flight_list_bloc.dart';

class FlightListState {
  final List<Flight> flights;
  final FlightListFetchingState flightListFetchingState;
  final StartBoardingState startBoardingState;
  final int selectedFlightIndex;
  const FlightListState(
      {
      this.selectedFlightIndex = -1,
      this.flights = const [],
      this.flightListFetchingState =
          const FlightListFetchingState(APIRequestState.initial, null),
      this.startBoardingState =
          const StartBoardingState(APIRequestState.initial, null)});

  FlightListState copyWith(
      {List<Flight>? flights,
      FlightListFetchingState? flightListFetchingState, StartBoardingState? startBoardingState}) {
    return FlightListState(
        flights: flights ?? this.flights,
        flightListFetchingState:
            flightListFetchingState ?? this.flightListFetchingState,
            startBoardingState: startBoardingState ?? this.startBoardingState);
  }
}

class FlightListFetchingState extends RestAPIState {
  const FlightListFetchingState(super.state, super.exception);
}

class StartBoardingState extends RestAPIState {
  const StartBoardingState(super.state, super.exception);
}
