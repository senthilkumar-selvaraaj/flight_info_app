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
  final Map<String, Pax>? laneBoardingInfo;
  
  bool showLoader(){
    return paxOnBoardingState.state == APIRequestState.loading || paxDeBoardingState.state == APIRequestState.loading;
  }

  int getTotalPaxList(){
    return paxResult?.data?.length ?? 0;
  }

  int getTotalBoardedPaxList(){
    return paxResult?.data?.where((element) => element.status == 'B').toList().length ?? 0;
  }

  int getInfantsCount(){
        return paxResult?.data?.where((element) => element.isInfant == true).toList().length ?? 0;
  }

  int getInfantsBoardedCount(){
        return paxResult?.data?.where((element) => element.isInfant == true && element.status == 'B').toList().length ?? 0;
  }

  String getBoadringInfo(){
    return "${paxResult?.total ?? ''}  YTB=(${paxResult?.ytbCount})   -   INFT ${paxResult?.infant ?? ''} ";
  }

  const FlightBoardingState({
    this.laneBoardingInfo ,
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
      Map<String, Pax>? laneBoardingInfo,
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
        laneBoardingInfo: laneBoardingInfo ?? this.laneBoardingInfo,
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

 Map<String, dynamic> getOnBoardRequestJson() {
    return {
      "session_ref_id": sessionId,
      "pnr_no": pax?.pnr ,
      "sequence_no": pax?.seqNo,
      "iata_code": pax?.iataCode,
      "flight_no": pax?.flightNo
      };
  }

 Map<String, dynamic> getDeBoardRequestJson() {
    return {
      "session_ref_id": sessionId,
      "pnr_no": pax?.pnr ,
      "sequence_no": pax?.seqNo,
      "iata_code": pax?.iataCode,
      "flight_no": pax?.flightNo
      };
  }

   Map<String, dynamic> getEndBoardRequestJson() {
    return {
      "session_ref_id": sessionId
    };
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
