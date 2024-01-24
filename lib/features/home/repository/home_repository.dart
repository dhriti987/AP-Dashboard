import 'package:dio/dio.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';

class HomeRepository {
  final ApiService _apiService;
  final listPlantsURL = "/dashboard/plant/";

  HomeRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<Plant>> getAllPlants() async {
    final api = _apiService.getApi();
    try {
      var response = await api.get(listPlantsURL);
      return Plant.listFromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to fetch data from server"]);
    }
  }
}
