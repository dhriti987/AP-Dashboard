import 'package:dio/dio.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';

class UnitAnalysisRepository {
  final ApiService _apiService;
  final unit24hrURL = "/dashboard/unit-time-series?unit=";

  UnitAnalysisRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<List<dynamic>> getUnit24hrData(int id) async {
    final api = _apiService.getApi();
    try {
      var response = await api.get(unit24hrURL + id.toString());
      return response.data["unit_data"];
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to fetch data from server"]);
    }
  }
}
