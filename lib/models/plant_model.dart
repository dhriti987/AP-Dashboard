class Plant {
  final String name;

  Plant({required this.name});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(name: json['name']);
  }

  static List<Plant> listFromJson(List<dynamic> data) {
    return data.map((e) => Plant.fromJson(e)).toList();
  }
}
