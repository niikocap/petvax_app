import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/services/storage_service.dart';

import '../../../app/models/appointment_model.dart';
import '../../../app/models/clinic_model.dart';
import '../../../app/models/pet_model.dart';

enum DashboardView { loading, loaded, error }

class DashboardController extends GetxController with SnackBarMixin {
  var view = DashboardView.loading.obs;
  var searchQuery = ''.obs;
  Rx<bool> isTyped = false.obs;
  GetConnect connect = GetConnect();
  final clinics =
      <Clinic>[
        Clinic(
          id: 1,
          name: "Happy Paws Veterinary Clinic",
          location: "123 Main St, Downtown",
          openingTime: "8:00 AM",
          closingTime: "8:00 PM",
          distance: "0.8 miles",
          image: "https://picsum.photos/200/300",
          latitude: 14.608621039357965,
          longitude: 120.99449157714845,
        ),
        Clinic(
          id: 2,
          name: "Pet Care Medical Center",
          location: "456 Oak Avenue, Midtown",
          openingTime: "8:00 AM",
          closingTime: "8:00 PM",
          distance: "1.2 miles",
          image: "https://picsum.photos/200/301",
          latitude: 14.605072967009649,
          longitude: 120.98951339721681,
        ),
        Clinic(
          id: 3,
          name: "Animal Health Associates",
          location: "789 Pine Road, Uptown",
          openingTime: "8:00 AM",
          closingTime: "8:00 PM",
          distance: "2.1 miles",
          image: "https://picsum.photos/200/302",
          latitude: 14.600753948717715,
          longitude: 121.02006912231447,
        ),
      ].obs;

  final pets =
      <Pet>[
        Pet(id: 1, name: "Buddy", species: "Dog"),
        Pet(id: 2, name: "Whiskers", species: "Cat"),
        Pet(id: 3, name: "Charlie", species: "Rabbit"),
      ].obs;

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
    await fetchClinics();
    await fetchPets();
    await fetchAppointments();
    view(DashboardView.loaded);
    super.onInit();
  }

  fetchClinics() async {
    var res = await connect.get('clinic/all');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch clinics: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      clinics.value = data.map((e) => Clinic.fromJson(e)).toList();
    }
  }

  fetchPets() async {
    var res = await connect.get(
      'pet/owner/${(await Storage.getString(key: 'userId'))}',
    );
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch pets: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      pets.value = data.map((e) => Pet.fromJson(e)).toList();
    }
  }

  fetchAppointments() async {
    var res = await connect.get(
      'booking/user/${(await Storage.getString(key: 'userId'))}?limit=3',
    );
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch appointments: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      appointments.value = data.map((e) => Appointment.fromJson(e)).toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery(query);
    if (!isTyped.value) {
      isTyped(true);
      Future.delayed(Duration(seconds: 2)).then((onValue) {
        isTyped(false);
        Get.toNamed('/clinics', arguments: {'search_param': searchQuery.value});
      });
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
