part of 'flight_list_bloc.dart';


sealed class FlightListEvent {}

class FetchFlightListEvent extends FlightListEvent{
    FetchFlightListEvent();
}

class StartBoardingEvent extends FlightListEvent{
    Flight flight;
    StartBoardingEvent(this.flight);
}


