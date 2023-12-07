import 'package:bloc/bloc.dart';
import 'package:flight_info_app/models/api_state.dart';
import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/repos/floght_list_repository.dart';

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
       print(flights.length);
         emit(state.copyWith(flights: flights, flightListFetchingState: const FlightListFetchingState(APIRequestState.sucess, null)));
      }catch(e){
         emit(state.copyWith(flightListFetchingState: FlightListFetchingState(APIRequestState.faulure, e as Exception)));
         emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.initial, null)));
      }
  }

  void onStartBoarding(StartBoardingEvent event, Emitter<FlightListState> emit ) async{
      emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.loading, null)));
      try{
        await repo.getFlightList();
         emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.sucess, null)));
      }catch(e){
         emit(state.copyWith(flightListFetchingState:  FlightListFetchingState(APIRequestState.faulure, e as Exception)));
         emit(state.copyWith(flightListFetchingState: const FlightListFetchingState(APIRequestState.initial, null)));
      }
  }

}
