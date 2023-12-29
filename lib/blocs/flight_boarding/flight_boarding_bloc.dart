import 'package:aai_chennai/utils/strings.dart';
import 'package:aai_chennai/utils/themes.dart';
import 'package:bloc/bloc.dart';
import 'package:aai_chennai/models/api_state.dart';
import 'package:aai_chennai/models/flight_list.dart';
import 'package:aai_chennai/models/pxt_list.dart';
import 'package:aai_chennai/repos/flight_boarding.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:flutter/material.dart';

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
    on<ListenCCOKEvent>(listenCCOK);
    on<UpdateLaneBoardingInfo>(updateLaneBoardingInfo);
  }

  void listenCCOK(
      ListenCCOKEvent event, Emitter<FlightBoardingState> emit) async {
    SocketClient().listenBoardingEvent((p0, p1) {
      if (p1.isNotEmpty) {
        if (p0 == cCOKStatus) {
          List<String> fields = p1.split("\n");
          if (fields.length > 4) {
            Map<String, BoardingStatus>? laneBoardingInfo = state.laneBoardingInfo;
            laneBoardingInfo ??= {};
            laneBoardingInfo[fields[4].replaceAll(' ', '')] = BoardingStatus(p0, Pax(
                seqNo: fields[0].replaceAll(' ', ''),
                seatNo: fields[1].replaceAll(' ', ''),
                pnr: fields[2].replaceAll(' ', ''),
                name: fields[3].replaceAll(' ', '')));
            add(UpdateLaneBoardingInfo(laneBoardingInfo));
          }
        } 
        else if(p0 == cEOKStatus) {
           Map<String, BoardingStatus>? laneBoardingInfo = state.laneBoardingInfo;
            laneBoardingInfo ??= {};
            laneBoardingInfo[p1.split('\n')[0].split('\n')[0]] = BoardingStatus(p0, null);
            add(UpdateLaneBoardingInfo(laneBoardingInfo));
        }
      }
      add(const FetchPaxListEvent());
    });
  }

  void updateLaneBoardingInfo(
      UpdateLaneBoardingInfo event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(laneBoardingInfo: event.laneBoardingInfo));
  }

  void onUpdateSessionId(
      UpdateSessionIdEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(sessionId: event.sessionId));
  }

  void onUpdateFlight(
      UpdateFlightInfoEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(flight: event.flight));
  }

  void onUpdatePax(
      UpdateSelectedPaxEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(pax: event.pax));
  }

  void onFetchPaxList(
      FetchPaxListEvent event, Emitter<FlightBoardingState> emit) async {
    emit(state.copyWith(
        paxListFetchingState:
            const PaxListFetchingState(APIRequestState.loading, null)));
    try {
      final paxResult = await repo.getPaxList(state.getPaxListRequestJson());
      Pax? pax = state.pax;
      if (pax != null) {
        final index = paxResult.data
            ?.indexWhere((element) => pax?.seqNo == element.seqNo);
        if (index != null && index != -1) {
          pax = paxResult.data?[index];
        }
      }
      emit(state.copyWith(
          paxes: paxResult.data ?? [],
          pax: pax,
          paxResult: paxResult,
          paxListFetchingState:
              const PaxListFetchingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxListFetchingState:
              PaxListFetchingState(APIRequestState.failure, e as Exception)));
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
      final paxResult = await repo.getPaxList(state.getPaxListRequestJson());

      Pax? pax = state.pax;
      pax?.status = 'Board';
      emit(state.copyWith(
          paxes: paxResult.data ?? [],
          paxResult: paxResult,
          pax: pax,
          paxOnBoardingState:
              const PaxOnBoardingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxOnBoardingState:
              PaxOnBoardingState(APIRequestState.failure, e as Exception)));
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
      final paxResult = await repo.getPaxList(state.getPaxListRequestJson());
      Pax? pax = state.pax;
      pax?.status = 'Deboard';
      emit(state.copyWith(
          paxes: paxResult.data ?? [],
          paxResult: paxResult,
          pax: pax,
          paxDeBoardingState:
              const PaxDeBoardingState(APIRequestState.success, null)));
    } catch (e) {
      emit(state.copyWith(
          paxDeBoardingState:
              PaxDeBoardingState(APIRequestState.failure, e as Exception)));
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
          endBoardingState:
              EndBoardingState(APIRequestState.failure, e as Exception)));
      emit(state.copyWith(
          endBoardingState:
              const EndBoardingState(APIRequestState.initial, null)));
    }
  }

  void onSearch(
      SearchtextChangedEvent event, Emitter<FlightBoardingState> emit) async {
    List<Pax> all = state.paxResult?.data ?? [];
    String keyword = event.keyword.toLowerCase();
    if (keyword.isEmpty) {
      emit(state.copyWith(paxes: all));
    } else {
      List<Pax> paxes = all
          .where((element) =>
              (element.name ?? '').toLowerCase().contains(keyword) ||
              (element.pnr ?? '').toLowerCase().contains(keyword) ||
              (element.seatNo ?? '').toLowerCase().contains(keyword) ||
              (element.seqNo ?? '').toLowerCase().contains(keyword) ||
              (element.origin ?? '').toLowerCase().contains(keyword) ||
              (element.destination ?? '').toLowerCase().contains(keyword))
          .toList();
      emit(state.copyWith(paxes: paxes));
    }
  }
}

class BoardingStatus {
  //CCTG, CCWW, CCDF
  final String command;
  final Pax? pax;
  BoardingStatus(this.command, this.pax);


String getName(){
     return pax?.name ?? '';
  }
  String getStatusMessage(){
      if(command == cCOKStatus){
        return pax?.getBoardingMessage() ?? '';
      }
      else if(command == cEOKStatus){
        return "Invalid boarding pass";
      }

      return "";
  }
  
  String getStatusTitle(){
      if(command == cCOKStatus){
        return 'Boarderd';
      }
      else if(command == cEOKStatus){
        return "Invalid";
      }
      return "";
  }

  Color getColor(AppTheme them){
    if(command == cCOKStatus){
        return them.laneBoardingTitleColor;
      }
      else if(command == cEOKStatus){
        return Colors.red;
      }
       return them.laneBoardingTitleColor;
  }

   Color getStatusColor(AppTheme them){
    if(command == cCOKStatus){
        return them.laneBoardingValueColor;
      }
      else if(command == cEOKStatus){
        return Colors.red;
      }
       return them.laneBoardingValueColor;
  }

  Color getBorderColor(AppTheme them){
    if(command == cCOKStatus){
        return them.laneBorderColor;
      }
      else if(command == cEOKStatus){
        return Colors.red;
      }
       return them.laneBoardingTitleColor;
  }

}