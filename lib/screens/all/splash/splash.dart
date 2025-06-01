import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/screens/all/splash/splash_cb.dart';

import '../../../app/widgets/custom_text.dart';

class Splash extends GetView<SplashController> {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Obx(
            () => switch (controller.view.value) {
              SplashView.loading => _loading(),
              SplashView.loaded => _loaded(),
              SplashView.error => _error(),
            },
          ),
        ),
      ),
    );
  }

  _loading() {
    return CircularProgressIndicator();
  }

  _loaded() {
    return CustomText(text: "App Loaded");
  }

  _error() {
    return CustomText(text: "App Error");
  }
}
