import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';

class LoginRepository {
  final ApiService _apiService;
  final SharedPreferences _sharedPreferences;
  final loginURL = "/api/token/";

  LoginRepository(
      {required ApiService apiService,
      required SharedPreferences sharedPreferences})
      : _apiService = apiService,
        _sharedPreferences = sharedPreferences;

  Future<void> login(String username, String password) async {
    final api = _apiService.getApiWithoutHeader();
    FormData data =
        FormData.fromMap({"username": username, "password": password});
    try {
      var response = await api.post(loginURL, data: data);
      var decodedToken = JwtDecoder.decode(response.data["access"]);
      await _sharedPreferences.setInt("userId", decodedToken["user_id"]);
      await _sharedPreferences.setString(
          "accessToken", response.data['access']);
      await _sharedPreferences.setString(
          "refreshToken", response.data['refresh']);
      await _sharedPreferences.setBool("isAdmin", decodedToken["is_admin"]);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ["Incorrect Credentials", e.response?.data['detail']]);
      // print(e.response?.data);
    }
  }
}
