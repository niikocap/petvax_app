class MedicalRecord {
  int id;
  String date;
  String type;
  String description;
  String veterinarian;
  String notes;

  MedicalRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.veterinarian,
    required this.notes,
  });
}
