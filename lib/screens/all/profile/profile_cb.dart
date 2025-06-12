// Controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/models/user_model.dart';
import 'package:petvax/app/services/storage_service.dart';

enum ProfileView { loading, loaded, error }

class PetOwnerController extends GetxController {
  final RxString activeTab = 'pets'.obs;
  var view = ProfileView.loading.obs;

  UserModel? user;

  final pets = <Pet>[
    Pet(
      id: 1,
      name: "Buddy",
      type: "Golden Retriever",
      age: "3 years",
      image:
          "https://images.unsplash.com/photo-1552053831-71594a27632d?w=200&h=200&fit=crop",
      vaccinated: true,
      lastBooking: "2 days ago",
    ),
    Pet(
      id: 2,
      name: "Luna",
      type: "British Shorthair",
      age: "2 years",
      image:
          "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200&h=200&fit=crop",
      vaccinated: true,
      lastBooking: "1 week ago",
    ),
    Pet(
      id: 3,
      name: "Max",
      type: "French Bulldog",
      age: "4 years",
      image:
          "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=200&h=200&fit=crop",
      vaccinated: true,
      lastBooking: "3 days ago",
    ),
  ];

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  void editProfile() {
    Get.snackbar(
      'Edit Profile',
      'Profile editing functionality',
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.blue.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  void viewBookings() {
    Get.snackbar(
      'My Bookings',
      'Viewing bookings functionality',
      backgroundColor: Colors.purple.shade50,
      colorText: Colors.purple.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  void addPet() {
    Get.snackbar(
      'Add Pet',
      'Add new pet functionality',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  void editPet(Pet pet) {
    Get.snackbar(
      'Edit Pet',
      'Editing ${pet.name}',
      backgroundColor: Colors.orange.shade50,
      colorText: Colors.orange.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onInit() async {
    user = await Storage.getUser();
    view(ProfileView.loaded);
    super.onInit();
  }
}

class PetOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetOwnerController());
  }
}

// Model Classes
class Pet {
  final int id;
  final String name;
  final String type;
  final String age;
  final String image;
  final bool vaccinated;
  final String lastBooking;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.image,
    required this.vaccinated,
    required this.lastBooking,
  });
}

class OwnerData {
  final String name;
  final String location;
  final String phone;
  final String email;
  final String joinDate;
  final int totalBookings;
  final double rating;
  final int reviewCount;
  final String avatar;

  OwnerData({
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
    required this.joinDate,
    required this.totalBookings,
    required this.rating,
    required this.reviewCount,
    required this.avatar,
  });
}
