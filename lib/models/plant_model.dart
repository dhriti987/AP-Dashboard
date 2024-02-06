class Plant {
  final int id;
  final String name;
  final double totalGeneration;

  Plant({
    required this.name,
    required this.id,
    required this.totalGeneration,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json["id"],
        name: json['name'],
        totalGeneration: json["total_generation"] / 1.0);
  }

  static List<Plant> listFromJson(List<dynamic> data) {
    return data.map((e) => Plant.fromJson(e)).toList();
  }
}
