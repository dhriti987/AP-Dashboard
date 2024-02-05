class Plant {
  final int id;
  final String name;

  Plant({required this.name, required this.id});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(id: json["id"], name: json['name']);
  }

  static List<Plant> listFromJson(List<dynamic> data) {
    return data.map((e) => Plant.fromJson(e)).toList();
  }
}
