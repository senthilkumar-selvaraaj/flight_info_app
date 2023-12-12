
class User {
    String? name;
    String? role;
    String? airlineRefId;
    String? userRefId;
    String? airline;
    String? iataCode;
    String? authToken;
    String? refreshToken;
    String? appId;
    String? userAgent;
    String? logoLight;
    String? logoDark;
    User({
        this.name,
        this.role,
        this.airlineRefId,
        this.userRefId,
        this.airline,
        this.iataCode,
        this.authToken,
        this.refreshToken,
        this.appId,
        this.userAgent,
        this.logoLight,
        this.logoDark
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        role: json["role"],
        airlineRefId: json["airline_ref_id"],
        userRefId: json["user_ref_id"],
        airline: json["airline"],
        iataCode: json["iata_code"],
        authToken: json["auth_token"],
        refreshToken: json["refresh_token"],
        appId: json["app_id"],
        userAgent: json["user_agent"],
        logoLight: json["logo_light"],
        logoDark: json["logo_dark"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "airline_ref_id": airlineRefId,
        "user_ref_id": userRefId,
        "airline": airline,
        "iata_code": iataCode,
        "auth_token": authToken,
        "refresh_token": refreshToken,
        "app_id": appId,
        "user_agent": userAgent,
        "logo_light":logoLight,
        "logo_dark": logoDark
    };
}