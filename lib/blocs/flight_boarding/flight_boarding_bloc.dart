
import 'package:bloc/bloc.dart';
import 'package:aai_chennai/models/api_state.dart';
import 'package:aai_chennai/models/flight_list.dart';
import 'package:aai_chennai/models/pxt_list.dart';
import 'package:aai_chennai/repos/flight_boarding.dart';
import 'package:aai_chennai/services/socket_client.dart';
import 'package:aai_chennai/utils/strings.dart';

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
       
        SocketClient().listenBoardingEvent((p0) {
          List<String> query = p0.split("\u0002CCOK\u0003");
      if (query.length > 1) {
         print("CCCC===> ${query}" );
        List<String> fields = query[1].split("\n");
        if (fields.length > 3) {
          Map<String, Pax>? laneBoardingInfo = state.laneBoardingInfo;
          laneBoardingInfo ??= {};
          laneBoardingInfo[fields[3].replaceAll(' ', '')] = Pax(
                  seqNo: fields[0].replaceAll(' ', ''),
                  seatNo: fields[1].replaceAll(' ', ''),
                  pnr: fields[2].replaceAll(' ', ''));
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
      if(pax != null){
       final index = paxResult.data?.indexWhere((element) => pax?.seqNo == element.seqNo);
       if(index != null && index != -1){
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
