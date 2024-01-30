import 'package:dio/dio.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';

class UnitEditRepository {
  final ApiService _apiService;
  final unitByPlantURL = "/dashboard/unit/";
  final unitAddUrl = "";

  UnitEditRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<List<Unit>> getAllUnitsByPlant(String plantName) async {
    final api = _apiService.getApi();
    try {
      var response = await api.get(unitByPlantURL + plantName);
      return Unit.listFromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to fetch data from server"]);
    }
  }

  Future<Unit> addUnit(String pointId, String systemGuid, int plantId,
      String unit, String code, String ratedPower) async {
    final api = _apiService.getApi();
    var data = FormData.fromMap({
      "point_id": pointId,
      "system_guid": systemGuid,
      "plant": plantId,
      "unit": unit,
      "code": code,
      "max_rated_power": ratedPower
    });
    try {
      var response = await api.post(unitAddUrl, data: data);
      return Unit.fromJson(response.data);
    } on DioException catch (e) {
      print(e.response);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to add data from server"]);
    }
  }
}
