class Pet {
  final int id;
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? color;
  final double? weight;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.color,
    this.weight,
  });

  factory Pet.fromJson(json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'] ?? "canine",
    );
  }
}
