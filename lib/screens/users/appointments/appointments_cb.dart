import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

enum AppointmentsView { loading, loaded, error }

class AppointmentsController extends GetxController with SnackBarMixin {
  Settings settings = Get.find<Settings>();
  var view = AppointmentsView.loading.obs;
  var searchQuery = TextEditingController();

  @override
  void onInit() async {
    view(AppointmentsView.loaded);
    super.onInit();
  }
}

class AppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentsController>(() => AppointmentsController());
  }
}
