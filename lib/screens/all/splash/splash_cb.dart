import 'dart:async';

import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/appointment_model.dart';
import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/models/pet_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

import '../../../app/services/storage_service.dart';

enum SplashView { loading, loaded, error }

class SplashController extends GetxController {
  var view = SplashView.loading.obs;
  var loadingText = "".obs;
  var dots = ".".obs;
  Timer? _timer;

  @override
  void onInit() async {
    final settings = Get.find<Settings>();
    loadingText("Loading user data");
    var user = await Storage.getUser();
    if (user != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (dots.value.length == 3) {
          dots.value = ".";
        } else {
          dots.value += ".";
        }
      });
      settings.user = user;
      loadingText("Loading pets data");

      settings.pets(
        (await GetConnect().get(
          '${AppStrings.baseUrl}pet/owner/${user.id}',
        )).body['data']?.map<Pet>((e) => Pet.fromJson(e)).toList(),
      );
      dots.value = "";
      loadingText("Loading clinics data");
      settings.clinics(
        (await GetConnect().get(
          '${AppStrings.baseUrl}clinic/all',
        )).body['data']?.map<Clinic>((e) => Clinic.fromJson(e)).toList(),
      );
      dots.value = "";
      loadingText("Loading appointments data");
      settings.appointments(
        (await GetConnect().get('${AppStrings.baseUrl}booking/user/${user.id}'))
            .body['data']
            ?.map<Appointment>((e) => Appointment.fromJson(e))
            .toList(),
      );
      _timer?.cancel();
      Get.offAndToNamed('/home');
    } else {
      Get.offAndToNamed('/auth');
    }
    view(SplashView.loaded);
    super.onInit();
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.put(Settings());
  }
}
