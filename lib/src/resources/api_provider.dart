import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/widgets/Strings.dart';

class ApiProvider {
  Dio _dio;
  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
//  String _baseUrl = 'http://192.168.210.169:2001';
  String _baseUrl = "http://192.168.0.107/api_geofancing/";

  ApiProvider() {
    SharedPreferencesHelper.getToken().then((token) {
      Options options = Options(
          receiveTimeout: 5000,
          baseUrl: _baseUrl,
          connectTimeout: 5000,
          headers: {'Authorization': token},
          contentType: ContentType.parse("application/json")
      );

      _dio = Dio(options);
      _setupLoggingInterceptor();
    });
  }

  Future<Dio> _syncConnection() async {
    Dio _dio;
    Options options = Options(
        receiveTimeout: 5000,
        connectTimeout: 5000,
        baseUrl: _baseUrl,
        contentType: ContentType.parse("application/json"));
    _dio = Dio(options);
    return _dio;
  }
  Future<Dio> _syncConn() async {
    var token = await SharedPreferencesHelper.getToken();
    print("data token: " + token);
    Dio _dio;
    Options options = Options(
        receiveTimeout: 5000,
        connectTimeout: 5000,
        baseUrl: _baseUrl,
        headers: {'Authorization': token},
        contentType: ContentType.parse("application/json"));
    _dio = Dio(options);
    return _dio;
  }

  Future<Dio> _syncConnWithoutToken() async {
    Dio _dio;
    Options options = Options(
        receiveTimeout: 5000,
        connectTimeout: 5000,
        baseUrl: _baseUrl,
        contentType: ContentType.parse("application/json"));
    _dio = Dio(options);
    return _dio;
  }

  String _handleError(Error error) {
    print(error);
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
          "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
          "Received invalid status code: ${error.response.statusCode}";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured "+error.toString();
    }
    return errorDescription;
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    _dio.interceptor.request.onSend = (Options options) {
      print("--> ${options.method} ${options.path}");
      print("Header: ${options.headers}");
      print("Content type: ${options.contentType}");
      print("Body: ${options.data}");
      print("<-- END HTTP");
      return options;
    };

    _dio.interceptor.response.onSuccess = (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
        (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
    };
  }

  Future<MemberModels> login({Map<String, dynamic> body}) async {
//    final _dio = await _syncConn();
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/login.php", data: json.encode(body));
      print(response.data.toString());
      return MemberModels.fromJson(response.data);
    } catch (error, _) {
      return MemberModels.withError(_handleError(error));
    }
  }

  void getLang({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response = await _dio.post("/get_language.php",
          data: json.encode(body));
      print(response.data);
      return response.data;
    } catch (error, _) {
//      return _handleError(error);
    }
  }
}