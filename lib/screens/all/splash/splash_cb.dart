import 'package:get/get.dart';

import '../../../app/services/storage_service.dart';

enum SplashView { loading, loaded, error }

class SplashController extends GetxController {
  var view = SplashView.loading.obs;

  @override
  void onInit() async {
    await Future.delayed(Duration(seconds: 1));
    view(SplashView.loaded);
    //await Storage.saveBool(key: 'isLoggedIn', value: false);
    var isLoggedIn = await Storage.getBool(key: 'isLoggedIn');
    if (isLoggedIn == true) {
      Get.offAndToNamed('/home');
    } else {
      Get.offAndToNamed('/auth');
    }
    super.onInit();
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
