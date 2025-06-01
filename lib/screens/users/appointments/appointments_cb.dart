import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';

import '../../../app/models/appointment_model.dart';
import '../../../app/services/storage_service.dart';

enum AppointmentsView { loading, loaded, error }

class AppointmentsController extends GetxController with SnackBarMixin {
  var view = AppointmentsView.loading.obs;
  GetConnect connect = GetConnect();
  var searchQuery = TextEditingController();
  final appointments =
      <Appointment>[
        Appointment(
          id: 1,
          date: "May 28, 2025",
          clinicName: "Happy Paws Veterinary Clinic",
          serviceName: "Annual Checkup",
          petName: "Buddy",
          amount: "\$85.00",
          status: "Confirmed",
        ),
        Appointment(
          id: 2,
          date: "June 2, 2025",
          clinicName: "Pet Care Medical Center",
          serviceName: "Vaccination",
          petName: "Whiskers",
          amount: "\$45.00",
          status: "Pending",
        ),
        Appointment(
          id: 3,
          date: "May 30, 2025",
          clinicName: "Animal Health Associates",
          serviceName: "Dental Cleaning",
          petName: "Charlie",
          amount: "\$120.00",
          status: "Completed",
        ),
      ].obs;

  @override
  void onInit() async {
    connect.baseUrl = AppStrings.baseUrl;
    view(AppointmentsView.loaded);
    await fetchAppointments();
    super.onInit();
  }

  fetchAppointments() async {
    var res = await connect.get(
      'booking/user/${(await Storage.getString(key: 'userId'))}',
    );
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch appointments: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      appointments.value = data.map((e) => Appointment.fromJson(e)).toList();
    }
  }
}

class AppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentsController>(() => AppointmentsController());
  }
}
