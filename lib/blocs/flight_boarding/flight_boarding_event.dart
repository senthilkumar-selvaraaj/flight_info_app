part of 'flight_boarding_bloc.dart';

class FlightBoardingEvent {
  const FlightBoardingEvent();
}

class UpdateSessionIdEvent extends FlightBoardingEvent{
  final String sessionId;
  UpdateSessionIdEvent(this.sessionId);
}

class UpdateFlightInfoEvent extends FlightBoardingEvent{
  final Flight flight;
  UpdateFlightInfoEvent(this.flight);
}

class UpdateSelectedPaxEvent extends FlightBoardingEvent{
  final Pax pax;
  UpdateSelectedPaxEvent(this.pax);
}

class FetchPaxListEvent extends FlightBoardingEvent{
  const FetchPaxListEvent();
}

class BoardingPaxEvent extends FlightBoardingEvent{
  const BoardingPaxEvent();
}

class DeBoardingPaxEvent extends FlightBoardingEvent{
  const DeBoardingPaxEvent();
}

class EndBoardingEvent extends FlightBoardingEvent{
  const EndBoardingEvent();
}

class SearchtextChangedEvent extends FlightBoardingEvent{
  final String keyword;
  const SearchtextChangedEvent(this.keyword);
}

class ListenCCOKEvent extends FlightBoardingEvent{
  const ListenCCOKEvent();
}

class UpdateLaneBoardingInfo extends FlightBoardingEvent{
 final Map<String, BoardingStatus> laneBoardingInfo;
  const UpdateLaneBoardingInfo(this.laneBoardingInfo);
}


