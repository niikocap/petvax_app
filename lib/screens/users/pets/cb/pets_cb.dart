import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';

import '../../../../app/models/pet_model.dart';
import '../../../../app/services/storage_service.dart';

enum PetsView { loading, loaded, error }

class PetsController extends GetxController with SnackBarMixin {
  GetConnect connect = GetConnect();
  var view = PetsView.loading.obs;
  final pets =
      <Pet>[
        Pet(id: 1, name: "Buddy", species: "Dog"),
        Pet(id: 2, name: "Whiskers", species: "Cat"),
        Pet(id: 3, name: "Charlie", species: "Rabbit"),
      ].obs;
  @override
  void onInit() async {
    connect.baseUrl = AppStrings.baseUrl;
    await fetchPets();
    view(PetsView.loaded);
    super.onInit();
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
}

class PetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetsController>(() => PetsController());
  }
}
