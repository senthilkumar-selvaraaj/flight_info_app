import 'dart:convert';
import 'dart:io';
import 'package:flight_info_app/utils/global_storage.dart';
import 'package:http/http.dart' as http;

enum HttpRequest implements HttpBaseRequest {
  login,
  logout,
  refreshToken,
  flightList;
  

  @override
  String get url {
    switch (this) {
      case HttpRequest.login:
        return '${APIConfig.basApiUrl}user/signin';
      case HttpRequest.logout:
        return '${APIConfig.basApiUrl}user/logout';
     case HttpRequest.refreshToken:
        return '${APIConfig.basApiUrl}user/refreshtoken';
        case HttpRequest.flightList:
        return '${APIConfig.basApiUrl}airline/flight/list';
      default:
        return '';
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case HttpRequest.flightList:
        return HttpMethod.get;
      default:
        return HttpMethod.post;
    }
  }

  @override
  Map<String, String> get headers {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-app-id': 'Workstation',
      'x-app-version': '1.0.0',
      'x-user-agent': 'Windows',
    };
    if (Global.storage.accessToken != null) {
      headers.addAll({'x-access-token': 'Bearer ${Global.storage.accessToken}'});
    }
    return headers;
  }
}

class APIConfig {
  static const basApiUrl = "https://egate.kartantech.com/api/v1/";
}

// Base request
abstract class HttpBaseRequest {
  String get url;
  HttpMethod get method;
  Map<String, String> get headers;
}

// HTTP Mehtod
enum HttpMethod {
  post,
  get,
  put,
  delete;

  String get value {
    switch (this) {
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.delete:
        return 'DELETE';
    }
  }
}

// Service abstract class
abstract class HttpService {
  final List<Files> files;
  final Map<String, dynamic> body;
  final HttpRequest request;
  final String path;
  final String query;
  const HttpService(
      {this.path = '',
      this.query = '',
      required this.request,
      this.body = const {},
      this.files = const []});

  void send();
  void post();
  void get();
  void put();
  void delete();
  void renewToken();
}

class Files {}

class HttpClient implements HttpService {
  @override
  final List<Files> files;
  @override
  final Map<String, dynamic> body;
  @override
  final HttpRequest request;
  @override
  final String path;
  @override
  final String query;

  http.MultipartRequest get httpRequest {
    var r = http.MultipartRequest(request.method.value, Uri.parse(request.url));
    for (var key in body.keys) {
      r.fields[key] = body[key] ?? '';
    }
    for (var key in request.headers.keys) {
      r.headers[key] = request.headers[key] ?? '';
    }
    return r;
  }

  const HttpClient(
      {this.path = '',
      this.query = '',
      required this.request,
      this.body = const {},
      this.files = const []});

  @override
  Future<dynamic> send() async {
    try {
      var response = await makeRequest();
      print(response.body);
      if (response.statusCode == 401 || response.statusCode == 406) {}
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }

  String getURL() {
    var url = request.url;
    if (path.isNotEmpty) {
      url = '$url/$path';
    }
    if (query.isNotEmpty) {
      url = '$url?$query';
    }
    return url;
  }

  @override
  Future<dynamic> post() async {
    try {
      var response = await makeRequest();
      print(response.body);
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }

  @override
  Future<dynamic> get() async {
    try {
      var response =
          await http.get(Uri.parse(getURL()), headers: request.headers);
          
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }

  @override
  Future<dynamic> put() async {
    print(getURL());
    try {
    var response = await http.put(Uri.parse(getURL()),
          headers: request.headers, body: jsonEncode(body));
          print(response.body);
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }

  @override
  Future<dynamic> delete() async {
    print(getURL());
    try {
      var response = await http.delete(Uri.parse(getURL()),
          headers: request.headers, body: jsonEncode(body));
          print(response.body);
      return handleResponse(response);
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }


  Future<dynamic> makeRequest() async {
    try {
      var response = await http.post(Uri.parse(getURL()),
          headers: request.headers, body: jsonEncode(body));
      return response;
    } on SocketException {
      throw NoInternetException(
          'No Internet connection. Please make sure your internet conenction.');
    }
  }

  dynamic handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body.toString());
      case 400:
        final jsonData = json.decode(response.body.toString());
        final message = jsonData["message"] ?? jsonData["error"]['message'] ?? 'Oops! Something went wrong';
        throw BadRequestException(message);
      default:
        throw UnExpectedException('Oops! Something went wrong');
    }
  }

  @override
  Future<bool> renewToken() async {
    return false;
  }
}

// API Exception handling

class AppException implements Exception {
  final String _message;

  AppException(this._message);

  @override
  String toString() {
    return _message;
  }
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class NoInternetException extends AppException {
  NoInternetException([message]) : super(message);
}

class UnExpectedException extends AppException {
  UnExpectedException([message]) : super(message);
}