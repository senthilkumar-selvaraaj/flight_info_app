part of 'flight_list_bloc.dart';


sealed class FlightListEvent {}

class FetchFlightListEvent extends FlightListEvent{
    FetchFlightListEvent();
}

class StartBoardingEvent extends FlightListEvent{
    StartBoardingEvent();
}
