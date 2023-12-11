part of 'flight_boarding_bloc.dart';

class FlightBoardingState {
  final String sessionId;
  final PaxList? paxResult;
  final Flight? flight;
  final List<Pax> paxes;
  final Pax? pax;
  final PaxListFetchingState paxListFetchingState;
  final PaxOnBoardingState paxOnBoardingState;
  final PaxDeBoardingState paxDeBoardingState;
  final EndBoardingState endBoardingState;

  const FlightBoardingState({
    this.paxes = const [],
    this.flight,
    this.paxResult,
    this.pax,
    this.sessionId = '',
    this.paxListFetchingState =
        const PaxListFetchingState(APIRequestState.initial, null),
    this.paxOnBoardingState =
        const PaxOnBoardingState(APIRequestState.initial, null),
    this.paxDeBoardingState =
        const PaxDeBoardingState(APIRequestState.initial, null),
    this.endBoardingState =
        const EndBoardingState(APIRequestState.initial, null),
  });

  FlightBoardingState copyWith(
      {
      List<Pax>? paxes,
      Flight? flight,
      Pax? pax,
      PaxList? paxResult,
      String? sessionId,
      PaxListFetchingState? paxListFetchingState,
      PaxOnBoardingState? paxOnBoardingState,
      PaxDeBoardingState? paxDeBoardingState,
      EndBoardingState? endBoardingState}) {
    return FlightBoardingState(
        paxes: paxes ?? this.paxes,
        flight: this.flight,
        pax: pax ?? this.pax,
        paxResult: paxResult ?? this.paxResult,
        sessionId: sessionId ?? this.sessionId,
        paxListFetchingState: paxListFetchingState ?? this.paxListFetchingState,
        paxDeBoardingState: paxDeBoardingState ?? this.paxDeBoardingState,
        paxOnBoardingState: paxOnBoardingState ?? this.paxOnBoardingState,
        endBoardingState: endBoardingState ?? this.endBoardingState);
  }

  Map<String, dynamic> getPaxListRequestJson() {
    return {"session_ref_id": sessionId};
  }
}

class PaxListFetchingState extends RestAPIState {
  const PaxListFetchingState(super.state, super.exception);
}

class PaxOnBoardingState extends RestAPIState {
  const PaxOnBoardingState(super.state, super.exception);
}

class PaxDeBoardingState extends RestAPIState {
  const PaxDeBoardingState(super.state, super.exception);
}

class EndBoardingState extends RestAPIState {
  const EndBoardingState(super.state, super.exception);
}
