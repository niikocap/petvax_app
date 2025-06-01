import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app/models/clinic_model.dart';

enum ClinicsView { loading, loaded, error }

class ClinicsController extends GetxController {
  var view = ClinicsView.loading.obs;
  var searchQuery = TextEditingController();
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

  @override
  void onInit() async {
    if (Get.arguments != null) searchQuery.text = Get.arguments['search_param'];
    view(ClinicsView.loaded);
    super.onInit();
  }
}

class ClinicsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicsController>(() => ClinicsController());
  }
}
