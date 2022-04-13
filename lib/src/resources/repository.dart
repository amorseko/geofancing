import 'package:dio/dio.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/get_picture_model.dart';
import 'package:geofancing/src/models/getversion_model.dart';
import 'package:geofancing/src/models/history_barang_model.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/models/history_pekerjaan.dart';
import 'package:geofancing/src/models/jenis_pekerjaan_model.dart';
import 'package:geofancing/src/models/list_bank_model.dart';
import 'package:geofancing/src/models/profile_model.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/api_provider.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/models/jarak_model.dart';
import 'package:geofancing/src/models/history_barang_model.dart';
import 'package:geofancing/src/models/jenis_part_model.dart';
import 'package:geofancing/src/models/kategori_part_model.dart';
import 'package:geofancing/src/models/list_barang_model.dart';
import 'package:geofancing/src/models/satuan_model.dart';
import 'package:geofancing/src/models/id_barang_detail_model.dart';
import 'package:geofancing/src/models/list_barang_detail_model.dart';
import 'package:geofancing/src/models/config_get_features.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<MemberModels> actLogin({Map<String, dynamic> body}) =>
      apiProvider.login(body: body);

  Future<StandartModels> actChangePassUser({Map<String, dynamic> body}) =>
      apiProvider.changePass(body: body);

  void getLang({Map<String, dynamic> body}) => apiProvider.getLang(body: body);

  Future<DefaultModel> submitAbsen({FormData formData}) =>
      apiProvider.submitAbsen(formData: formData);

  Future<DefaultModel> submitPenajuan({FormData formData}) =>
      apiProvider.submitPengajuan(formData: formData);

  Future<DefaultModel> submitDetailPengajuan({FormData formData}) =>
      apiProvider.submitDetailPengajuan(formData: formData);

  Future<HistoryModels> getHistoryAbsen({Map<String, dynamic> body}) =>
      apiProvider.getHistoryAbsen(body: body);

  Future<HistoryBarangModels> getHistoryBarang({Map<String, dynamic> body}) =>
      apiProvider.getHistoryBarang(body: body);

  Future<AbsenModels> getTodayAbsen({Map<String, dynamic> body}) =>
      apiProvider.getTodayAbsen(body: body);

  Future<JarakModels> RepogetJarak({Map<String, dynamic> body}) =>
      apiProvider.getJarak(body: body);

  Future<GetListJenisPartModels> fetchGetListJenisPart() =>
      apiProvider.fetchListJenisPartApi();

  Future<GetListJenisPekerjaanModel> fetchGetListJenisPekerjaan() =>
      apiProvider.fetchListJenisPekerjaanApi();

  Future<GetListKategoriPartModels> fetchGetListKategoriPart() =>
      apiProvider.fetchListKategoriPartApi();

  Future<GetListNamaBarangModels> fetchGetListNamaBarang(
          {Map<String, dynamic> body}) =>
      apiProvider.fetchListNamaBarangApi(body: body);

  Future<GetSatuanModels> fetchGetNamaSatuan({Map<String, dynamic> body}) =>
      apiProvider.fetctNamaSatuan(body: body);

  Future<IDBarangModels> fetchGetIdBarangDetail() =>
      apiProvider.fetchIdBarangDetail();

  Future<GetListBarangDetailModels> getListBarangDetail(
          {Map<String, dynamic> body}) =>
      apiProvider.getListBarangDetail(body: body);

  Future<StandartModels> fetchDelBarangDetail({Map<String, dynamic> body}) =>
      apiProvider.fetchDelBarangDetail(body: body);

  Future<HistoryPekerjaanModels> HistoryPekerjaan(
          {Map<String, dynamic> body}) =>
      apiProvider.fecthHistoryPekerjaan(body: body);

  Future<DefaultModel> submitPekerjaan({FormData formData}) =>
      apiProvider.ApiSubmitPekerjaan(formData: formData);

  Future<GetPictureModel> fetchGetImageSelected({Map<String, dynamic> body}) =>
      apiProvider.ApifetchGetImageSelected(body: body);

  Future<DefaultModel> submitChangeImage({FormData formData}) =>
      apiProvider.ApisubmitChangeImage(formData: formData);

  Future<StandartModels> actCheckUser({Map<String, dynamic> body}) =>
      apiProvider.checkUser(body: body);

  Future<StandartModels> actChangeProfile({Map<String, dynamic> body}) =>
      apiProvider.changeProfile(body: body);

  Future<ProfileModels> fetchProfile({Map<String, dynamic> body}) =>
      apiProvider.profile(body: body);

  Future<GetVersionModel> getVersion({Map<String, dynamic> body}) =>
      apiProvider.getVersion(body: body);


  Future<ConfigGetFeaturesModel> fetchConfigGetFeatures() => apiProvider.fetchconfiggetfeaturesApi();

  Future<ListBankModels> getListBank({Map<String, dynamic> body}) =>
      apiProvider.fetchListBank(body: body);

  Future<DefaultModel> submitCarBefore({FormData formData}) =>
      apiProvider.submitCarBefore(formData: formData);

  Future<HistoryCarWorkingModels> historyCarWorking(
      {Map<String, dynamic> body}) =>
      apiProvider.fetchHistoryCarWorking(body: body);

  Future<StandartModels> actChangeStatusWorkingCar({Map<String, dynamic> body}) =>
      apiProvider.changeStatusWorkingCar(body: body);
}
