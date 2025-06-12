import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/services.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/app/widgets/gradient_button.dart';
import 'package:petvax/screens/users/clinics/services_cb.dart';

class Services extends GetView<ServicesController> {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            ServicesView.loading => _loading(),
            ServicesView.loaded => _loaded(),
            ServicesView.error => _error(),
          },
        ),
      ),
    );
  }

  _loaded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SizedBox(
          height: 170.h,
          child: Stack(
            children: [
              Container(
                height: 90.h,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      controller.clinic?.image != null
                          ? "${AppStrings.imageUrl}${controller.clinic?.image}"
                          : 'https://picsum.photos/800/400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 30.h,
                child: SizedBox(
                  width: Get.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: Get.width - 40.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7.5.w),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(99),
                                    ),

                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                flex: 7,
                                child: CustomText(
                                  text: controller.clinic!.name,
                                  overflow: TextOverflow.visible,
                                  fontSize: 20,
                                  align: TextAlign.center,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          CustomText(
                            text: controller.clinic!.location,
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              SizedBox(width: 5.w),
                              CustomText(text: "4.3 stars"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              GestureDetector(
                onTap: () {
                  controller.activeIndex(0);
                },
                child: Column(
                  children: [
                    CustomText(text: "Grooming"),
                    Container(
                      height: 2.h,
                      width: 30.w,
                      color:
                          controller.activeIndex.value == 0
                              ? Colors.teal
                              : Colors.transparent,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.activeIndex(1);
                },
                child: Column(
                  children: [
                    CustomText(text: "Vaccine"),
                    Container(
                      height: 2.h,
                      width: 30.w,
                      color:
                          controller.activeIndex.value == 1
                              ? Colors.teal
                              : Colors.transparent,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.activeIndex(2);
                },
                child: Column(
                  children: [
                    CustomText(text: "Deworming"),
                    Container(
                      height: 2.h,
                      width: 30.w,
                      color:
                          controller.activeIndex.value == 2
                              ? Colors.teal
                              : Colors.transparent,
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Column(
          children: [
            Obx(() {
              final services = {
                'grooming':
                    controller.services
                        .where((s) => s.category == 'grooming')
                        .toList(),
                'vaccine':
                    controller.services
                        .where((s) => s.category == 'vaccine')
                        .toList(),
                'deworming':
                    controller.services
                        .where((s) => s.category == 'deworming')
                        .toList(),
              };

              final currentServices = switch (controller.activeIndex.value) {
                0 => services['grooming'],
                1 => services['vaccine'],
                2 => services['deworming'],
                _ => <ServicesModel>[],
              };

              if (currentServices == null || currentServices.isEmpty) {
                return Container();
              }

              return Container(
                height: Get.height - 300.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 5.w,
                    mainAxisSpacing: 5.h,
                  ),
                  itemCount: currentServices.length,
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 20.w,
                  //   vertical: 10.h,
                  // ),
                  itemBuilder: (_, index) {
                    final service = currentServices[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.r),
                                  ),
                                  child: Image.network(
                                    service.image != ""
                                        ? "${AppStrings.imageUrl}${service.image}"
                                        : 'https://picsum.photos/800/300',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.r),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5.h,
                                  right: 5.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: CustomText(
                                      text: "${service.price}",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.h,
                                  left: 10.w,
                                  right: 10.w,
                                  child: CustomText(
                                    text: service.name,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    align: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: service.description,
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  GradientButton(
                                    height: 35.h,
                                    width: double.infinity,
                                    text: "Book Now",
                                    onPressed: () {
                                      if (controller.pets.isEmpty) {
                                        controller.showErrorSnackbar(
                                          "You don't have any pets!",
                                        );
                                        return;
                                      }
                                      controller.book(
                                        service.id,
                                        service.price,
                                      );
                                    },
                                    gradientColors: [
                                      Colors.teal,
                                      Colors.tealAccent,
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  _error() {
    return Center(
      child: const Center(child: CustomText(text: 'Error loading clinics')),
    );
  }
}
