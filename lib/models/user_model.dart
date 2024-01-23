class UserModel {
  final String employeeId;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String contact;
  final bool isAdmin;

  UserModel(
      {required this.employeeId,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.contact,
      required this.isAdmin});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        employeeId: json["employee_id"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        contact: json["contact_no"],
        isAdmin: json["is_staff"]);
  }
  static List<UserModel> listFromJson(List<dynamic> data) =>
      List.from(data.map((e) => UserModel.fromJson(e)));
}
