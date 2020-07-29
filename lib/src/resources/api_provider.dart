import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/models/jarak_model.dart';
import 'package:geofancing/src/widgets/Strings.dart';
//import 'package:geofancing/src/resources/MyHttpOverrides.dart';

class ApiProvider {
  Dio _dio;
  Dio _dioSecond;

  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
//   String _baseUrl = 'http://13.229.237.174/api/';
  String _baseUrl = 'https://api-tayoga.septamedia.com/';
//  String _baseUrl = "http://192.168.0.107/api_geof/ancing/";

  ApiProvider() {
    SharedPreferencesHelper.getToken().then((token) {
      BaseOptions options = BaseOptions(
          receiveTimeout: 5000,
          baseUrl: _baseUrl,
          connectTimeout: 5000,
          headers: {'Authorization': token},
          contentType: Headers.formUrlEncodedContentType
      );

      BaseOptions optionsSecond = BaseOptions(
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
          receiveTimeout: 1000000,
          connectTimeout: 1000000,
          contentType: Headers.formUrlEncodedContentType);

      _dio = Dio(options);
      _dioSecond  = Dio(optionsSecond);
      _setupLoggingInterceptor();
    });
  }
  Future<Dio> _syncConnWithoutToken() async {
    Dio _dio;
    BaseOptions options = BaseOptions(
        receiveTimeout: 5000,
        connectTimeout: 5000,
        baseUrl: _baseUrl,
        contentType: Headers.formUrlEncodedContentType
    );
    _dio = Dio(options);
    return _dio;
  }

  Future<Dio> _syncFormData() async {
    Dio _dioSecond;
    BaseOptions optionsSecond = BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
        receiveTimeout: 1000000,
        connectTimeout: 1000000,
        contentType: Headers.formUrlEncodedContentType);
    _dioSecond = Dio(optionsSecond);
    return _dio;
  }


  String _handleError(error) {
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
      errorDescription = "Unexpected error occured " + error.toString();
    }
    return errorDescription;
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      SharedPreferencesHelper.getToken().then((token) {
        options.headers['Authorization'] = token;
//            options.headers['Authorization']="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBpZCI6ImFwcHNfTkh0Mm94IiwiY2FyZCI6IjgwMDAxOTU4MDA1ODcxOTkiLCJleHAiOjE1ODI3NDQ3MjcsInByb2plY3RpZCI6InJhbWF5YW5hX1JCSW0iLCJ1c2VyaWQiOiJkOTgwcGcifQ.f6lCh0Yg6dwgDLk1ksRGXvR3c76u0e5lVEO4ygzH_Yc";
        print("--> ${options.method} ${options.path}");
        print("Header: ${options.headers}");
        print("Content type: ${options.contentType}");
        print("Body: ${options.data}");
        print("<-- END HTTP");
      });
      return options;
    }, onResponse: (Response response) {
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
    }, onError: (DioError error) {
      print(error);
    }));
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
      final response =
          await _dio.post("/get_language.php", data: json.encode(body));
      print(response.data);
      return response.data;
    } catch (error, _) {
//      return _handleError(error);
    }
  }


  Future<DefaultModel> submitAbsen({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
//      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data: formData, onSendProgress:  (int sent, int total) {
//        print("progress >>> " +
//            ((sent / total) * 100).floor().toString() +
//            "%");
//      });

      print(formData);
      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data:formData);
      print("response absen : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<HistoryModels> getHistoryAbsen({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response =
      await _dio.post("/history_absen.php", data: json.encode(body));
      return HistoryModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<AbsenModels> getTodayAbsen({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response =
      await _dio.post("/absen.php", data: json.encode(body));
      return AbsenModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<JarakModels> getJarak({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response = await _dio.post("/jarak.php", data: json.encode(body));
      print(response.data);
      return JarakModels.fromJson(response.data);
    } catch (error, _) {
      return JarakModels.withError(_handleError(error));
//      return _handleError(error);
    }
  }

  Future<StandartModels> changePass({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/change_pass.php",
          data: json.encode(body));
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }


}
