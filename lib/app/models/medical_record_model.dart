class MedicalRecord {
  int id;
  String date;
  String type;
  String description;
  String veterinarian;
  String notes;
  String status;

  MedicalRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.veterinarian,
    required this.notes,
    required this.status,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as int,
      date: json['date'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      veterinarian: json['veterinarian'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'description': description,
      'veterinarian': veterinarian,
      'notes': notes,
      'status': status,
    };
  }
}
