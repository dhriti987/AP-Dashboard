import 'package:dio/dio.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/services/api_service.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/user_model.dart';

class SettingRepository {
  final ApiService _apiService;
  final listPlantsURL = "/dashboard/plant/";
  final listUsersURL = "/auth/users/";
  final addPlantUrl = "/dashboard/plant/add_plant/";
  final addUserUrl = "/auth/register/";

  SettingRepository({required ApiService apiService})
      : _apiService = apiService;

// -------------------------------------------------------
// Plants
// -------------------------------------------------------
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

  Future<Plant> addPlant(String plantName) async {
    final api = _apiService.getApi();
    var data = FormData.fromMap({
      "name": plantName,
    });
    try {
      var response = await api.post(addPlantUrl, data: data);
      return Plant.fromJson(response.data);
    } on DioException catch (e) {
      print(e.response);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to add data from server"]);
    }
  }

  Future<void> deletePlant(int plantId) async {
    final api = _apiService.getApi();
    try {
      await api.delete(listPlantsURL + plantId.toString());
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e, error: ["Delete Failed", "Unable to Delete the Unit"]);
    }
  }

// -------------------------------------------------------
// Users
// -------------------------------------------------------

  Future<List<UserModel>> getAllUsers() async {
    final api = _apiService.getApi();
    try {
      var response = await api.get(listUsersURL);
      return UserModel.listFromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to fetch data from server"]);
    }
  }

  Future<UserModel> addUser(
      String employeeId,
      String firstName,
      String lastName,
      String username,
      String email,
      String contactNo,
      String password,
      bool isAdmin) async {
    final api = _apiService.getApi();
    var data = FormData.fromMap({
      "employee_id": employeeId,
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "email": email,
      "password": password,
      "contact_no": contactNo,
      "is_staff": isAdmin,
    });
    try {
      var response = await api.post(addUserUrl, data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e.response);
      throw ApiException(
          exception: e,
          error: ["Unknown Error", "Unable to add data from server"]);
    }
  }

  Future<void> deleteUser(int userId) async {
    final api = _apiService.getApi();
    try {
      await api.delete(listUsersURL + userId.toString());
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e, error: ["Delete Failed", "Unable to Delete the Unit"]);
    }
  }

  Future<UserModel> editUser(UserModel user) async {
    final api = _apiService.getApi();
    var data = FormData.fromMap({
      "id": user.id,
      "employee_id": user.employeeId,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "username": user.username,
      "email": user.email,
      "contact_no": user.contact,
      "is_staff": user.isAdmin
    });
    try {
      var response =
          await api.patch(listUsersURL + user.id.toString(), data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(
          exception: e, error: ["Edit Failed", "Unable to Edit the Unit"]);
    }
  }
}
