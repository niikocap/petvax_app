import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';

import '../../../../app/services/storage_service.dart';

enum AddPetView { loading, loaded, error }

class AddPetController extends GetxController with SnackBarMixin {
  var view = AddPetView.loading.obs;
  GetConnect connect = GetConnect();
  // Form data
  final name = "".obs;
  final specie = "".obs;
  final breed = "".obs;
  final weight = "".obs;

  @override
  void onInit() async {
    super.onInit();
    connect.baseUrl = AppStrings.baseUrl;
    // Add listeners for real-time validation
    name.listen((value) => validateName());
    specie.listen((value) => validateSpecies());
    breed.listen((value) => validateBreed());
    weight.listen((value) => validateWeight());
    view(AddPetView.loaded);
  }

  // Observable variables
  final selectedImage = Rx<File?>(null);
  final birthDate = Rx<DateTime?>(null);
  final selectedGender = RxString('');
  final selectedOwnerId = RxString('');
  final selectedClinicId = RxString('');

  // Error states
  final nameError = RxString('');
  final speciesError = RxString('');
  final breedError = RxString('');
  final weightError = RxString('');
  final ownerError = RxString('');
  final clinicError = RxString('');

  // Loading state
  final isLoading = RxBool(false);

  // Dropdown data (replace with your actual data)
  final genderOptions = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
    {'value': 'unspecified', 'label': 'Unspecified'},
  ];

  final ownerOptions = [
    {'value': '1', 'label': 'John Doe'},
    {'value': '2', 'label': 'Jane Smith'},
    {'value': '3', 'label': 'Bob Johnson'},
  ];

  final clinicOptions = [
    {'value': '1', 'label': 'City Veterinary Clinic'},
    {'value': '2', 'label': 'Happy Pets Hospital'},
    {'value': '3', 'label': 'Animal Care Center'},
  ];

  // Image picker methods
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // Date picker
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDate.value = picked;
    }
  }

  // Validation methods
  void validateName() {
    if (name.value.isEmpty) {
      nameError.value = 'Pet name is required';
    } else if (name.value.length > 255) {
      nameError.value = 'Name must be less than 255 characters';
    } else {
      nameError.value = '';
    }
  }

  void validateSpecies() {
    if (specie.value.isEmpty) {
      speciesError.value = 'Species is required';
    } else if (specie.value.length > 255) {
      speciesError.value = 'Species must be less than 255 characters';
    } else {
      speciesError.value = '';
    }
  }

  void validateBreed() {
    if (breed.value.length > 255) {
      breedError.value = 'Breed must be less than 255 characters';
    } else {
      breedError.value = '';
    }
  }

  void validateWeight() {
    if (weight.value.isNotEmpty) {
      final w = double.tryParse(weight.value);
      if (w == null || w < 0) {
        weightError.value = 'Weight must be a valid positive number';
      } else {
        weightError.value = '';
      }
    } else {
      weightError.value = '';
    }
  }

  void validateOwner() {
    if (selectedOwnerId.value.isEmpty) {
      ownerError.value = 'Owner is required';
    } else {
      ownerError.value = '';
    }
  }

  void validateClinic() {
    if (selectedClinicId.value.isEmpty) {
      clinicError.value = 'Clinic is required';
    } else {
      clinicError.value = '';
    }
  }

  // Form validation
  bool validateForm() {
    validateName();
    validateSpecies();
    validateBreed();
    validateWeight();
    validateOwner();
    validateClinic();

    return nameError.value.isEmpty &&
        speciesError.value.isEmpty &&
        breedError.value.isEmpty &&
        weightError.value.isEmpty &&
        ownerError.value.isEmpty &&
        clinicError.value.isEmpty;
  }

  // Submit form
  Future<void> submitForm() async {
    // if (!validateForm()) return;

    isLoading.value = true;

    try {
      final formData = {
        'name': name.value,
        'species': specie.value,
        'breed': breed.value.isEmpty ? null : breed.value,
        'birth_date': birthDate.value?.toIso8601String().split('T')[0],
        'clinic_id': 1,
        'owner_id': (await Storage.getString(key: 'userId')).toString(),
        'weight': weight.value.isEmpty ? null : double.tryParse(weight.value),
        'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
      };

      var res = await connect.post('pet/add', formData);

      if (res.body['status'] != 'success') {
        throw Exception('Failed to add pet: ${res.body['message']}');
      }
      showSuccessSnackBar("Pet added successfully!");

      // Reset form
      resetForm();
      Get.back();
    } catch (e) {
      showErrorSn ackbar('Failed to add pet. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    name('');
    specie('');
    breed('');
    weight('');
    selectedImage.value = null;
    birthDate.value = null;
    selectedGender.value = '';
    selectedOwnerId.value = '';
    selectedClinicId.value = '';

    // Clear errors
    nameError.value = '';
    speciesError.value = '';
    breedError.value = '';
    weightError.value = '';
    ownerError.value = '';
    clinicError.value = '';
  }
}

class AddPetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPetController>(() => AddPetController());
  }
}
