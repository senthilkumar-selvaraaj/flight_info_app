
import 'dart:convert';

import 'package:aai_chennai/models/flight_list.dart';
import 'package:aai_chennai/services/api_service.dart';

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

   Future<String> startBoarding(Map<String,dynamic> body) async {
    try {
      final response = await  HttpClient(
          request: HttpRequest.startBoarding, body: body).send();
      try {
        return response['session_ref_id'];
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }
}
