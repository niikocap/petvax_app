class Pet {
  final int id;
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? color;
  final double? weight;
  final String? image;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.color,
    this.weight,
    this.image,
  });

  factory Pet.fromJson(json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'] ?? "canine",
      image: json['image'],
    );
  }
}
