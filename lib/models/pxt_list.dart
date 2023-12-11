// To parse this JSON data, do
//
//     final paxList = paxListFromJson(jsonString);

import 'dart:convert';

PaxList paxListFromJson(String str) => PaxList.fromJson(json.decode(str));

String paxListToJson(PaxList data) => json.encode(data.toJson());

class PaxList {
    List<Pax>? data;
    int? total;
    int? infant;
    int? boarded;

    PaxList({
        this.data,
        this.total,
        this.infant,
        this.boarded,
    });

    factory PaxList.fromJson(Map<String, dynamic> json) => PaxList(
        data: json["data"] == null ? [] : List<Pax>.from(json["data"]!.map((x) => Pax.fromJson(x))),
        total: json["total"],
        infant: json["infant"],
        boarded: json["boarded"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "infant": infant,
        "boarded": boarded,
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

    Pax({
        this.iataCode,
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
    });

    factory Pax.fromJson(Map<String, dynamic> json) => Pax(
        iataCode: json["iata_code"],
        flightNo: json["flight_no"],
        seqNo: json["seq_no"],
        pnr: json["pnr"],
        seatNo: json["seat_no"],
        name: json["name"],
        origin: json["origin"],
        destination: json["destination"]!,
        isWc: json["is_wc"],
        isSsr: json["is_ssr"],
        isInfant: json["is_infant"],
    );

    Map<String, dynamic> toJson() => {
        "iata_code":iataCode,
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
    };

    String description(){
      return "Selected: $seqNo | $pnr | $seatNo | MR/Ms $name | $origin > $destination";
    }
}
