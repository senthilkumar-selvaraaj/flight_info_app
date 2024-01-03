import 'dart:convert';
import 'package:aai_chennai/models/pxt_list.dart';
import 'package:aai_chennai/services/api_service.dart';

class FlightBoardingRepository {
  Future<PaxList> getPaxList(Map<String, dynamic> body) async {
    try {
      final response =
          await HttpClient(request: HttpRequest.paxList, body: body).send();
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
      await HttpClient(request: HttpRequest.paxBoarding, body: body).send();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deBoardPax(Map<String, dynamic> body) async {
    try {
      await HttpClient(request: HttpRequest.paxDeboarding, body: body).send();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> endBoarding(Map<String, dynamic> body) async {
    try {
      await HttpClient(request: HttpRequest.endBoarding, body: body).send();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> paxListExport(Map<String, dynamic> body) async {
    try {
      final r = await HttpClient(request: HttpRequest.exportPaxList, body: body)
          .send();
     return r;
    } catch (e) {
      rethrow;
    }
  }
}
