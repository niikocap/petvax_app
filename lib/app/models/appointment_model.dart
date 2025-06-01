class Appointment {
  final int id;
  final String date;
  final String clinicName;
  final String serviceName;
  final String petName;
  final String amount;
  final String status;

  Appointment({
    required this.id,
    required this.date,
    required this.clinicName,
    required this.serviceName,
    required this.petName,
    required this.amount,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['appointment_datetime'],
      clinicName: json['clinic']['name'],
      serviceName: json['service']['name'],
      petName: json['pet']['name'],
      amount: json['total_amount'].toString(),
      status: json['status'],
    );
  }
}
