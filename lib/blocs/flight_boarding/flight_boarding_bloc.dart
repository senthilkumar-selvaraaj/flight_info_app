

import 'package:bloc/bloc.dart';
import 'package:flight_info_app/models/api_state.dart';
import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/models/pxt_list.dart';
import 'package:flight_info_app/repos/flight_boarding.dart';

part 'flight_boarding_event.dart';
part 'flight_boarding_state.dart';

class FlightBoardingBloc
    extends Bloc<FlightBoardingEvent, FlightBoardingState> {
      final FlightBoardingRepository repo;
  FlightBoardingBloc(this.repo) : super(const FlightBoardingState()) {
    on<FetchPaxListEvent>(onFetchPaxList);
    on<BoardingPaxEvent>(onBoardingPax);
    on<DeBoardingPaxEvent>(onDeBoardingPax);
    on<EndBoardingEvent>(onEndBoarding);
    on<UpdateSessionIdEvent>(onUpdateSessionId);
    on<UpdateSelectedPaxEvent>(onUpdatePax);
    on<UpdateFlightInfoEvent>(onUpdateFlight);
    on<SearchtextChangedEvent>(onSearch);
  }

 void onUpdateSessionId(
      UpdateSessionIdEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        sessionId: event.sessionId));
  }

  void onUpdateFlight(
      UpdateFlightInfoEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
       flight: event.flight));
  }

  void onUpdatePax(
      UpdateSelectedPaxEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
       pax: event.pax));
  }

  void onFetchPaxList(
      FetchPaxListEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        paxListFetchingState:
            const PaxListFetchingState(APIRequestState.loading, null)));
    try {
      final paxResult = await repo.getPaxList(state.getPaxListRequestJson());
      emit(state.copyWith(
          paxes: paxResult.data ?? [],
          paxResult: paxResult,
          paxListFetchingState:
              const PaxListFetchingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxListFetchingState: PaxListFetchingState(
              APIRequestState.failure, e as Exception)));
      emit(state.copyWith(
          paxListFetchingState:
              const PaxListFetchingState(APIRequestState.initial, null)));
    }
  }

  void onBoardingPax(
      BoardingPaxEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        paxOnBoardingState:
            const PaxOnBoardingState(APIRequestState.loading, null)));
    try {
       await repo.onBoardPax(state.getOnBoardRequestJson());
        List<Pax> paxes = state.paxResult?.data ?? [];
      final index = state.paxResult?.data?.indexWhere((element) => element.pnr == state.pax?.pnr);
      if(index != null){
        paxes[index].status = "B";
      }
      final paxResult = PaxList(data: paxes, total: state.paxResult?.total, boarded: state.paxResult?.boarded, infant: state.paxResult?.infant);
      emit(state.copyWith(
        paxResult: paxResult,
          paxOnBoardingState:
              const PaxOnBoardingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxOnBoardingState: PaxOnBoardingState(
              APIRequestState.failure, e as Exception)));
      emit(state.copyWith(
          paxOnBoardingState:
              const PaxOnBoardingState(APIRequestState.initial, null)));
    }
  }

  void onDeBoardingPax(
      DeBoardingPaxEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        paxDeBoardingState:
            const PaxDeBoardingState(APIRequestState.loading, null)));
    try {
      await repo.deBoardPax(state.getDeBoardRequestJson());
      List<Pax> paxes = state.paxResult?.data ?? [];
      final index = state.paxResult?.data?.indexWhere((element) => element.pnr == state.pax?.pnr);
      if(index != null){
        paxes[index].status = "D";
      }
      final paxResult = PaxList(data: paxes, total: state.paxResult?.total, boarded: state.paxResult?.boarded, infant: state.paxResult?.infant);
      emit(state.copyWith(
        paxResult: paxResult,
          paxDeBoardingState:
              const PaxDeBoardingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxDeBoardingState: PaxDeBoardingState(
              APIRequestState.failure, e as Exception)));
      emit(state.copyWith(
          paxDeBoardingState:
              const PaxDeBoardingState(APIRequestState.initial, null)));
    }
  }

  void onEndBoarding(
      EndBoardingEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        endBoardingState:
            const EndBoardingState(APIRequestState.loading, null)));
    try {
      await repo.endBoarding(state.getEndBoardRequestJson());
      emit(state.copyWith(
          endBoardingState:
              const EndBoardingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          endBoardingState: EndBoardingState(
              APIRequestState.failure, e as Exception)));
      emit(state.copyWith(
          endBoardingState:
              const EndBoardingState(APIRequestState.initial, null)));
    }
  }

  void onSearch(
      SearchtextChangedEvent event, Emitter<FlightBoardingState> emit) async {
        List<Pax> all = state.paxResult?.data ?? [];
        String keyword = event.keyword.toLowerCase();
        if (keyword.isEmpty){
          emit(state.copyWith(paxes: all));
        }else{
          List<Pax> paxes = all.where((element) 
          => (element.name ?? '').toLowerCase().contains(keyword) ||
             (element.pnr ?? '').toLowerCase().contains(keyword) ||
            (element.seatNo ?? '').toLowerCase().contains(keyword) ||
            (element.seqNo ?? '').toLowerCase().contains(keyword) ||
            (element.origin ?? '').toLowerCase().contains(keyword) ||
            (element.destination ?? '').toLowerCase().contains(keyword)
           ).toList();
            emit(state.copyWith(paxes: paxes));
        }
  }
}
