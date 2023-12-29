// To parse this JSON data, do
//
//     final paxList = paxListFromJson(jsonString);

import 'dart:convert';

PaxList paxListFromJson(String str) => PaxList.fromJson(json.decode(str));

String paxListToJson(PaxList data) => json.encode(data.toJson());

class PaxList {
  List<Pax>? data;
  String? total;
  String? infant;
  int? ytbCount;

  PaxList({
    this.data,
    this.total,
    this.infant,
    this.ytbCount,
  });

  factory PaxList.fromJson(Map<String, dynamic> json) => PaxList(
        data: json["data"] == null
            ? []
            : List<Pax>.from(json["data"]!.map((x) => Pax.fromJson(x))),
        total: json["total_count"],
        infant: json["infant_count"],
        ytbCount: json["ytb_count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "infant": infant,
        "ytbCount": ytbCount,
      };
}

class Pax {
  String? iataCode;
  String? flightNo;
  String? seqNo;
  String? pnr;
  String? seatNo;
  String? name;
  String? origin;
  String? destination;
  bool? isWc;
  bool? isSsr;
  bool? isInfant;
  String? status;

 String getBoardingMessage(){
  return '$seqNo/$seatNo/$pnr/$name';
 }

  Pax(
      {this.iataCode,
      this.flightNo,
      this.seqNo,
      this.pnr,
      this.seatNo,
      this.name,
      this.origin,
      this.destination,
      this.isWc,
      this.isSsr,
      this.isInfant,
      this.status});

  factory Pax.fromJson(Map<String, dynamic> json) => Pax(
        iataCode: json["iata_code"],
        flightNo: json["flight_no"],
        seqNo: json["sequence_no"],
        pnr: json["pnr_no"],
        seatNo: json["seat_no"],
        name: json["name"],
        origin: json["origin"],
        destination: json["destination"]!,
        isWc: json["is_wc"],
        isSsr: json["is_ssr"],
        isInfant: json["is_infant"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "iata_code": iataCode,
        "flight_no": flightNo,
        "seq_no": seqNo,
        "pnr": pnr,
        "seat_no": seatNo,
        "name": name,
        "origin": origin,
        "destination": destination,
        "is_wc": isWc,
        "is_ssr": isSsr,
        "is_infant": isInfant,
        "status": status,
      };

  String description() {
    return "Selected: $seqNo  |  $pnr  |  $seatNo  |  $name  |  $origin > $destination";
  }

  String getName() {
    String prefix = "";
    if ((isSsr ?? false) == true) {
      prefix = "*";
    } else if ((isWc ?? false) == true) {
      prefix = "+";
    } else if ((isInfant ?? false) == true) {
      prefix = "**";
    }
    return "$prefix$name";
  }

  String paxButtonTitle() {
    if (status == null) return 'Board Pax';
    return status == 'Board' ? 'Deboard Pax' : 'Board Pax';
  }

  bool showManifest() {
    if (status == null) return true;
    return status != 'Board';
  }
}
