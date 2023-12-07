
import 'dart:convert';

import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/services/api_service.dart';

class FlightListRepository {
  Future<List<FlightList>> getFlightList() async {
    try {
      final response = await const HttpClient(
          request: HttpRequest.flightList).get();
      try {
      List<FlightList> list = flightListFromJson(json.encode(response));
      return list;
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }
}
