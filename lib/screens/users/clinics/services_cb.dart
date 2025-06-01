import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/services/storage_service.dart';

import '../../../app/models/pet_model.dart';
import '../../../app/models/services.dart';

enum ServicesView { loading, loaded, error }

class ServicesController extends GetxController with SnackBarMixin {
  var view = ServicesView.loading.obs;
  GetConnect connect = GetConnect();
  RxString selectedPet = ''.obs;
  RxInt activeIndex = 0.obs;
  Clinic? clinic;
  List<ServicesModel> services = [
    ServicesModel(
      id: 0,
      name: "Grooming",
      category: "grooming",
      description: "Sample description for grooming",
      price: 500,
      specie: "canine",
      size: "small",
      clinicId: 1,
      image: "https://picsum.photos/200/301",
    ),
    ServicesModel(
      id: 1,
      name: "Grooming 1",
      category: "grooming",
      description: "Sample description for grooming 1",
      price: 500,
      specie: "canine",
      size: "small",
      clinicId: 1,
      image: "https://picsum.photos/200/304",
    ),
    ServicesModel(
      id: 2,
      name: "Vaccine",
      category: "vaccine",
      description: "Sample description for vaccine",
      price: 500,
      specie: "canine",
      size: "small",
      clinicId: 1,
      image: "https://picsum.photos/200/302",
    ),
    ServicesModel(
      id: 3,
      name: "Deworming",
      category: "deworming",
      description: "Sample description for deworming",
      price: 500,
      specie: "canine",
      size: "small",
      clinicId: 1,
      image: "https://picsum.photos/200/303",
    ),
  ];
  List<Pet> pets = [];
  @override
  void onInit() async {
    clinic = Get.arguments;
    connect.baseUrl = AppStrings.baseUrl;
    await loadServices(clinicId: clinic!.id);
    await loadPets(owner: (await Storage.getString(key: 'userId')).toString());
    view(ServicesView.loaded);
    super.onInit();
  }

  loadServices({clinicId}) async {
    var res = await connect.get('service/clinic/$clinicId');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch services: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      services = data.map((e) => ServicesModel.fromJson(e)).toList();
    }
  }

  loadPets({owner}) async {
    var res = await connect.get(
      'pet/owner/${await Storage.getString(key: 'userId')}',
    );
    print(res.body);
    pets = res.body['data'].map<Pet>((e) => Pet.fromJson(e)).toList();
    if (pets.isNotEmpty) selectedPet(pets.map((e) => e.name).toList()[0]);
  }

  bookNow(id, amount) async {
    Get.back();
    print({
      "clinic_id": clinic!.id,
      "service_id": id,
      "pet_id":
          pets
              .firstWhere(
                (e) => e.name.toLowerCase() == selectedPet.value.toLowerCase(),
              )
              .id,
      "client_id": await Storage.getString(key: 'userId'),
      "staff_id": null,
      "appointment_datetime": DateTime.now().toIso8601String(),
      "notes": "any",
      "total amount": amount,
      "status": "pending",
    });
    var res = await connect.post('booking/add', {
      "clinic_id": clinic!.id,
      "service_id": id,
      "pet_id":
          pets
              .firstWhere(
                (e) => e.name.toLowerCase() == selectedPet.value.toLowerCase(),
              )
              .id,
      "client_id": await Storage.getString(key: 'userId'),
      "staff_id": 1,
      "appointment_datetime": DateTime.now().toIso8601String(),
      "notes": "any",
      "total_amount": amount,
      "status": "pending",
    });
    if (res.body['status'] == 'success') {
      showSuccessSnackBar("Booking has been scheduled!");
    } else {
      showErrorSnackbar("Something went wrong, try again or contact admin!");
    }
  }
}

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesController>(() => ServicesController());
  }
}
