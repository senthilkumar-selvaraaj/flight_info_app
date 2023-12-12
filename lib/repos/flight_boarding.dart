
import 'dart:convert';
import 'package:flight_info_app/models/pxt_list.dart';
import 'package:flight_info_app/services/api_service.dart';

class FlightBoardingRepository {
  Future<PaxList> getPaxList(Map<String, dynamic> body) async {
    try {
      final response = await HttpClient(
          request: HttpRequest.paxList,
          body: body).send();
          print(response);
      try {
         PaxList paxList = paxListFromJson(json.encode(response));
         return paxList;
      } catch (e) {
        throw BadRequestException('Data Exception');
      }
    } catch (e) {
      rethrow;
    }
  }
Future<void> onBoardPax(Map<String, dynamic> body) async {
    try {
    final response =  await HttpClient(
          request: HttpRequest.paxBoarding,
          body: body).send();
      print(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deBoardPax(Map<String, dynamic> body) async {
    try {
      await HttpClient(
          request: HttpRequest.paxDeboarding,
          body: body).send();
      
    } catch (e) {
      rethrow;
    }
  }

  Future<void> endBoarding(Map<String, dynamic> body) async {
    try {
      await HttpClient(
          request: HttpRequest.endBoarding,
          body: body).send();
      
    } catch (e) {
      rethrow;
    }
  }

}