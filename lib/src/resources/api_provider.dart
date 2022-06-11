import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:geofancing/src/models/car_working_model_done.dart';
import 'package:geofancing/src/models/config_get_features.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/get_picture_model.dart';
import 'package:geofancing/src/models/getversion_model.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/models/history_pekerjaan.dart';
import 'package:geofancing/src/models/jenis_pekerjaan_model.dart';
import 'package:geofancing/src/models/list_bank_model.dart';
import 'package:geofancing/src/models/profile_model.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/models/jarak_model.dart';
import 'package:geofancing/src/models/history_barang_model.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/models/jenis_part_model.dart';
import 'package:geofancing/src/models/kategori_part_model.dart';
import 'package:geofancing/src/models/list_barang_model.dart';
import 'package:geofancing/src/models/satuan_model.dart';
import 'package:geofancing/src/models/id_barang_detail_model.dart';
import 'package:geofancing/src/models/list_barang_detail_model.dart';

class ApiProvider {
  Dio _dio;
  Dio _dioSecond;

  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
//   String _baseUrl = 'http://13.229.237.174/api/';
  // String _baseUrl = 'http://api-tayoga.septamedia.com/';
//  String _baseUrl = "http://192.168.0.107/api_geof/ancing/";
//   String _baseUrl = 'https://api-toyoga.toyoga.co.id/';

  String _baseUrl = "https://api-toyoga.toyoga.id/";

  ApiProvider() {
    SharedPreferencesHelper.getToken().then((token) {
      BaseOptions options = BaseOptions(
          receiveTimeout: 5000,
          baseUrl: _baseUrl,
          connectTimeout: 5000,
          headers: {'Authorization': token},
          contentType: Headers.formUrlEncodedContentType);

      BaseOptions optionsSecond = BaseOptions(
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
          receiveTimeout: 1000000,
          connectTimeout: 1000000,
          contentType: Headers.formUrlEncodedContentType);

      _dio = Dio(options);
      _dioSecond = Dio(optionsSecond);
      _setupLoggingInterceptor();
    });
  }
  Future<Dio> _syncConnWithoutToken() async {
    Dio _dio;
    BaseOptions options = BaseOptions(
        receiveTimeout: 50000,
        connectTimeout: 50000,
        baseUrl: _baseUrl,
        contentType: Headers.formUrlEncodedContentType);
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
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = "Request cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout";
          break;
        case DioErrorType.other:
          errorDescription = "Please check internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout";
          break;
        case DioErrorType.response:
          errorDescription =
          "Received invalid status code: ${error.response.statusCode}";
          break;
        default:
          errorDescription = "Not Found Method";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured ";
    }
    return errorDescription;
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      SharedPreferencesHelper.getToken()
          .then((token) {
        options.headers['Authorization'] = token;
        print("--> ${options.method} ${options.path}");
        print("Header: ${options.headers}");
        print("Content type: ${options.contentType}");
        print("Body: ${options.data}");
        print("<-- END HTTP");
      });
      return handler.next(options);
    }, onResponse: (response, handler) {
      print(
          "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
      String responseAsString = response.data.toString();

      ///Logging to Firebase
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
      return handler.next(response);
    }, onError: (DioError e, handler) {
      print(
          'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');


      return handler.next(e);
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
      final response = await _dioSecond.post(_baseUrl + "save_absen_new.php",
          data: formData);
      print("response absen : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<DefaultModel> submitPengajuan({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
//      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data: formData, onSendProgress:  (int sent, int total) {
//        print("progress >>> " +
//            ((sent / total) * 100).floor().toString() +
//            "%");
//      });

      print(formData);
      final response = await _dioSecond.post(_baseUrl + "save_pengajuan.php",
          data: formData);
      print("response absen : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<DefaultModel> submitDetailPengajuan({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
//      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data: formData, onSendProgress:  (int sent, int total) {
//        print("progress >>> " +
//            ((sent / total) * 100).floor().toString() +
//            "%");
//      });

      print(formData);
      final response = await _dioSecond.post(_baseUrl + "tambah_pb_temp.php",
          data: formData);
      print("response pb temp : $response");
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
          await _dio.post("/history_absen_new.php", data: json.encode(body));
      return HistoryModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<HistoryBarangModels> getHistoryBarang(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response = await _dio.post("/list_permintaan_barang_mekanik.php",
          data: json.encode(body));
      print(response.data);
      return HistoryBarangModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<AbsenModels> getTodayAbsen({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response =
          await _dio.post("/absen_new.php", data: json.encode(body));
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
      final response =
          await _dio.post("/change_pass.php", data: json.encode(body));
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }

  Future<GetListJenisPartModels> fetchListJenisPartApi() async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/jenis_part.php");
      print(response.data);
      return GetListJenisPartModels.fromJson(response.data);
    } catch (error, stack) {
      print(stack.toString());
      return GetListJenisPartModels.withError(_handleError(error));
    }
  }

  Future<GetListKategoriPartModels> fetchListKategoriPartApi() async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/kategori_part.php");
      print(response.data);
      return GetListKategoriPartModels.fromJson(response.data);
    } catch (error, stack) {
      print(stack.toString());
      return GetListKategoriPartModels.withError(_handleError(error));
    }
  }

  Future<GetListNamaBarangModels> fetchListNamaBarangApi(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response =
          await _dio.post("/nama_barang.php", data: json.encode(body));
      print(response.data);
      return GetListNamaBarangModels.fromJson(response.data);
    } catch (error, _) {
      return GetListNamaBarangModels.withError(_handleError(error));
    }
  }

  Future<GetSatuanModels> fetctNamaSatuan({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/satuan.php", data: json.encode(body));
      print(response.data);
      return GetSatuanModels.fromJson(response.data);
    } catch (error, _) {
      return GetSatuanModels.withError(_handleError(error));
    }
  }

  Future<IDBarangModels> fetchIdBarangDetail() async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/create_id_detail.php");
      print(response.data);
      return IDBarangModels.fromJson(response.data);
    } catch (error, stack) {
      print(stack.toString());
      return IDBarangModels.withError(_handleError(error));
    }
  }

  Future<GetListBarangDetailModels> getListBarangDetail(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response = await _dio.post("/list_permintaan_barang_detail.php",
          data: json.encode(body));
      return GetListBarangDetailModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<StandartModels> fetchDelBarangDetail(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response =
          await _dio.post("/delete_barang_detail.php", data: json.encode(body));
      print(response.data);
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }

  Future<HistoryPekerjaanModels> fecthHistoryPekerjaan(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response =
          await _dio.post("/history_pekerjaan.php", data: json.encode(body));

      print(response.data);
      return HistoryPekerjaanModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<GetListJenisPekerjaanModel> fetchListJenisPekerjaanApi() async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/list_pekerjaan_cmb.php");
      print(response.data);
      return GetListJenisPekerjaanModel.fromJson(response.data);
    } catch (error, stack) {
      print(stack.toString());
      return GetListJenisPekerjaanModel.withError(_handleError(error));
    }
  }

  Future<DefaultModel> ApiSubmitPekerjaan({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
//      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data: formData, onSendProgress:  (int sent, int total) {
//        print("progress >>> " +
//            ((sent / total) * 100).floor().toString() +
//            "%");
//      });

      print(formData);
      final response = await _dioSecond.post(_baseUrl + "save_pekerjaan.php",
          data: formData);
      print("response pb temp : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<GetPictureModel> ApifetchGetImageSelected(
      {Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response = await _dio.post("selected_pict_pekerjaan.php",
          data: json.encode(body));
      print(response.data);
      return GetPictureModel.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<DefaultModel> ApisubmitChangeImage({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
//      final response = await _dioSecond.post(_baseUrl+"save_absen.php", data: formData, onSendProgress:  (int sent, int total) {
//        print("progress >>> " +
//            ((sent / total) * 100).floor().toString() +
//            "%");
//      });

      print(formData);
      final response = await _dioSecond
          .post(_baseUrl + "update_image_pekerjaan.php", data: formData);
      print("response pb temp : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<StandartModels> checkUser({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response =
          await _dio.post("/check_user.php", data: json.encode(body));
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }

  Future<StandartModels> changeProfile({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response =
      await _dio.post("/change_profile.php", data: json.encode(body));
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }

  Future<ProfileModels> profile({Map<String, dynamic> body}) async {
//    final _dio = await _syncConn();
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/fetch_profile.php", data: json.encode(body));
      print(response.data.toString());
      return ProfileModels.fromJson(response.data);
    } catch (error, _) {
      return ProfileModels.withError(_handleError(error));
    }
  }

  Future<GetVersionModel> getVersion({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response =
      await _dio.post("app_version.php", data: json.encode(body));
      print(response.data);
      return GetVersionModel.fromJson(response.data);
    } catch (error, _) {
      return GetVersionModel.withError(_handleError(error));
    }
  }

  Future<ConfigGetFeaturesModel> fetchconfiggetfeaturesApi() async {
    final _dio = await _syncConnWithoutToken();
    try {
      final response = await _dio.post("/features.php");
      print(response.data);
      return ConfigGetFeaturesModel.fromJson(response.data);
    } catch (error, stack) {
      print("Error");
      print(stack.toString());
      return ConfigGetFeaturesModel.withError(_handleError(error));
    }
  }

  Future<ListBankModels> fetchListBank({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    print(body);
    try {
      final response = await _dio.post(
          "list_bank.php", data: json.encode(body)
      );
      print(response.data);
      return ListBankModels.fromJson(response.data);
    } catch (error, _) {
//      return _handleError(error);
    }
  }

  Future<DefaultModel> submitCarBefore({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
      print(formData);
      final response = await _dioSecond
          .post(_baseUrl + "save_car_working_before.php", data: formData);
      print("response pb temp : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

  Future<HistoryCarWorkingModels> fetchHistoryCarWorking({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      final response =
      await _dio.post("/history_working_car_before.php", data: json.encode(body));
      print(response.data);
      // print("data list car working" + response.data);
      return HistoryCarWorkingModels.fromJson(response.data);
    } catch (error, _) {
     // return _handleError(error);
      print(error.toString());
      return HistoryCarWorkingModels.withError(_handleError(error));
    }
  }

  Future<HistoryCarWorkingModelsDone> fetchHistoryCarWorkingDone({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();

    try {
      print(body);
      final response =
      await _dio.post("/history_working_car_before.php", data: json.encode(body));

      print(response.data);
      return HistoryCarWorkingModelsDone.fromJson(response.data);
    } catch (error, _) {
      // return _handleError(error);
      print(error.toString());
      return HistoryCarWorkingModelsDone.withError(_handleError(error));
    }
  }

  Future<StandartModels> changeStatusWorkingCar({Map<String, dynamic> body}) async {
    final _dio = await _syncConnWithoutToken();
    try {
      // print(body.toString());
      final response =
      await _dio.post("/accept_working.php", data: json.encode(body));
      print(response.data);
      return StandartModels.fromJson(response.data);
    } catch (error, _) {
      return StandartModels.withError(_handleError(error));
    }
  }

  Future<DefaultModel> submitCarAfter({FormData formData}) async {
    final _dioSecond = await _syncConnWithoutToken();
    try {
      print(formData);
      final response = await _dioSecond
          .post(_baseUrl + "save_car_working_after.php", data: formData);
      print("response pb temp : $response");
      print(response.data.toString());
      return DefaultModel.fromJson(response.data);
    } catch (error, _) {
      print("error kesini :");
      print(_handleError(error));
    }
  }

}
