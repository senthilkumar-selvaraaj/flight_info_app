import 'dart:convert';

List<Flight> flightListFromJson(String str) => List<Flight>.from(json.decode(str).map((x) => Flight.fromJson(x)));

String flightListToJson(List<Flight> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Flight {
    String? airline;
    String? iataCode;
    String? flightNo;
    String? origin;
    DateTime? depDate;
    String? destination;
    DateTime? arrTime;
    bool? isDelayed;

    String statusMessage(){
      return (isDelayed ?? false) ? "DELAYED" : "ONTIME";
    }

    Flight({
        this.airline,
        this.iataCode,
        this.flightNo,
        this.origin,
        this.depDate,
        this.destination,
        this.arrTime,
        this.isDelayed,
    });

    factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        airline: json["airline"],
        iataCode: json["iata_code"],
        flightNo: json["flight_no"],
        origin: json["origin"],
        depDate: json["dep_date"] == null ? null : DateTime.parse(json["dep_date"]),
        destination: json["destination"],
        arrTime: json["arr_time"] == null ? null : DateTime.parse(json["arr_time"]),
        isDelayed: json["is_delayed"],
    );

    Map<String, dynamic> toJson() => {
        "airline": airline,
        "iata_code": iataCode,
        "flight_no": flightNo,
        "origin": origin,
        "dep_date": depDate?.toIso8601String(),
        "destination": destination,
        "arr_time": arrTime?.toIso8601String(),
        "is_delayed": isDelayed,
    };
}
