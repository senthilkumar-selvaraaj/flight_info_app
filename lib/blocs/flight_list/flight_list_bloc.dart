import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flight_info_app/models/api_state.dart';
import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/repos/floght_list_repository.dart';
import 'package:flight_info_app/services/lane_service.dart';
import 'package:flight_info_app/services/socket_client.dart';
import 'package:flight_info_app/utils/strings.dart';

part 'flight_list_event.dart';
part 'flight_list_state.dart';

class FlightListBloc extends Bloc<FlightListEvent, FlightListState> {
  final FlightListRepository repo;
  FlightListBloc(this.repo) : super(const FlightListState()) {
    on<FetchFlightListEvent>(onFetchFlightList);
    on<StartBoardingEvent>(onStartBoarding);
  }

  void onFetchFlightList(FetchFlightListEvent event, Emitter<FlightListState> emit ) async{
      emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.loading, null)));
      try{
       final flights =  await repo.getFlightList();
         emit(state.copyWith(flights: flights, flightListFetchingState: const FlightListFetchingState(APIRequestState.success, null)));
      }catch(e){
         emit(state.copyWith(flightListFetchingState: FlightListFetchingState(APIRequestState.failure, e as Exception)));
         emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.initial, null)));
      }
  }

  Future<void> onStartBoarding(StartBoardingEvent event, Emitter<FlightListState> emit ) async{
      emit(state.copyWith(startBoardingState: const StartBoardingState(APIRequestState.loading, null)));
      Map<String, dynamic> request = {"flight_no": event.flight.flightNo??'', "gate_ref_id": LaneService.getLaneIds()};
      try{
         final sessionId = await repo.startBoarding(request);
         emit(state.copyWith(sessionId: sessionId, startBoardingState: const StartBoardingState(APIRequestState.success, null)));
      }catch(e){
         emit(state.copyWith(startBoardingState:  StartBoardingState(APIRequestState.failure, e as Exception)));
         emit(state.copyWith(startBoardingState: const StartBoardingState(APIRequestState.initial, null)));
      }
  }

}
