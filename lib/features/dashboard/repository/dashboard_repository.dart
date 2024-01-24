import 'package:dio/dio.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';

class DashboardRepository {
  final ApiService _apiService;
  final unitByPlantURL = "/dashboard/unit/";

  DashboardRepository({required ApiService apiService})
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
}
