
import 'dart:convert';

import 'package:flight_info_app/models/flight_list.dart';
import 'package:flight_info_app/services/api_service.dart';

class FlightListRepository {
  Future<List<Flight>> getFlightList() async {
    try {
      final response = await const HttpClient(
          request: HttpRequest.flightList).send();
      try {
      List<Flight> list = flightListFromJson(json.encode(response));
      return list;
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }

   Future<void> startBoarding(Map<String,dynamic> body) async {
    try {
      final response = await  HttpClient(
          request: HttpRequest.startBoarding, body: body).send();
          print(response);
      try {
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }
}
