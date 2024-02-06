import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/router/router.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';

class LoginRepository {
  final ApiService _apiService;
  final SharedPreferences _sharedPreferences;
  final AppRouter _appRouter;
  final loginURL = "/api/token/";
  final refreshTokenURL = "/api/token/refresh/";

  LoginRepository(
      {required ApiService apiService,
      required SharedPreferences sharedPreferences,
      required AppRouter appRouter})
      : _apiService = apiService,
        _sharedPreferences = sharedPreferences,
        _appRouter = appRouter {
    isAuthenticated();
  }

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
      _appRouter.isAuthenticated = true;
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ["Incorrect Credentials", e.response?.data['detail']]);
      // print(e.response?.data);
    }
  }

  getToken() async {
    final api = _apiService.getApiWithoutHeader();
    FormData data = FormData.fromMap(
        {"refresh": _sharedPreferences.getString("refreshToken")});
    try {
      var response = await api.post(refreshTokenURL, data: data);
      await _sharedPreferences.setString(
          "accessToken", response.data['access']);
    } on DioException catch (e) {
      print(e);
    }
  }

  isAuthenticated() {
    String? refresToken = _sharedPreferences.getString("refreshToken");
    if (refresToken != null &&
        JwtDecoder.getRemainingTime(refresToken).inDays > 0) {
      getToken();
      _appRouter.isAuthenticated = true;
      _appRouter.isAdmin = _sharedPreferences.getBool("isAdmin") ?? false;
      Timer.periodic(const Duration(hours: 23), (timer) {
        if (JwtDecoder.getRemainingTime(refresToken).inDays > 0) {
          getToken();
        } else {
          _appRouter.isAuthenticated = false;
          _appRouter.getRouter().go('/login');
        }
      });
    }
  }

  logout() async {
    await _sharedPreferences.remove("refreshToken");
  }
}
