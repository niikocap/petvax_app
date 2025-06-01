import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/models/services.dart';
import 'package:petvax/app/widgets/custom_bottomsheet.dart';
import 'package:petvax/app/widgets/custom_text.dart';
import 'package:petvax/app/widgets/gradient_button.dart';
import 'package:petvax/screens/users/clinics/services_cb.dart';

import '../../../app/components/date_picker.dart';

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
                    image: NetworkImage(controller.clinic!.image),
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
                      width: Get.width - 60.w,
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
              List<ServicesModel> groomings =
                  controller.services
                      .where((service) => service.category == 'grooming')
                      .toList();
              List<ServicesModel> vaccines =
                  controller.services
                      .where((service) => service.category == 'vaccine')
                      .toList();
              List<ServicesModel> dewormings =
                  controller.services
                      .where((service) => service.category == 'deworming')
                      .toList();
              if (controller.activeIndex.value == 0) {
                return Container(
                  height: Get.height - 300.h,

                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  child: ListView.builder(
                    itemCount: groomings.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      var data = groomings[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 20.h,
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
                            Container(
                              height: 100.w,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                image: DecorationImage(
                                  image: NetworkImage(groomings[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: groomings[index].name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                CustomText(text: groomings[index].description),
                                CustomText(
                                  text: "From P${groomings[index].price}",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            GradientButton(
                              height: 48.h,
                              text: "Book Now",
                              onPressed: () {
                                if (controller.pets.isEmpty) {
                                  controller.showErrorSnackbar(
                                    "You don't have any pets!",
                                  );
                                  return;
                                }
                                CustomBottomsheet(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Additional Details",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                      SizedBox(height: 10.h),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: "Select pet to book",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.grey[900],
                                          ),
                                          SizedBox(height: 5.h),
                                          CustomDropdown<String>(
                                            hintText: 'Select pet',
                                            items:
                                                controller.pets
                                                    .map((e) => e.name)
                                                    .toList(),
                                            initialItem:
                                                controller.pets
                                                    .map((e) => e.name)
                                                    .toList()[0],
                                            onChanged: (value) {
                                              controller.selectedPet(value);
                                            },
                                            decoration:
                                                CustomDropdownDecoration(
                                                  closedFillColor:
                                                      Colors.grey[200],
                                                  headerStyle:
                                                      GoogleFonts.poppins(),
                                                  hintStyle:
                                                      GoogleFonts.poppins(),
                                                  listItemStyle:
                                                      GoogleFonts.poppins(),
                                                  //:
                                                ),
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CustomDateTimePicker(),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                      GradientButton(
                                        text: "Continue Booking",
                                        onPressed: () {
                                          controller.bookNow(
                                            data.id,
                                            data.price,
                                          );
                                        },
                                        gradientColors: [
                                          Colors.teal,
                                          Colors.tealAccent,
                                        ],
                                        height: 48.h,
                                      ),
                                    ],
                                  ),
                                ).floating();
                              },
                              gradientColors: [Colors.teal, Colors.tealAccent],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (controller.activeIndex.value == 1) {
                return SizedBox(
                  height: Get.height - 300.h,

                  child: ListView.builder(
                    itemCount: vaccines.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: Get.height - 300.h,
                        margin: EdgeInsets.only(bottom: 10.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 10.h,
                        ),
                        child: ListView.builder(
                          itemCount: vaccines.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 20.h,
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
                                  Container(
                                    height: 100.w,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          vaccines[index].image,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: vaccines[index].name,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomText(
                                        text: vaccines[index].description,
                                      ),
                                      CustomText(
                                        text: "From P${vaccines[index].price}",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  GradientButton(
                                    height: 48.h,
                                    text: "Book Now",
                                    onPressed: () {
                                      CustomBottomsheet(
                                        child: Column(),
                                      ).floating();
                                    },
                                    gradientColors: [
                                      Colors.teal,
                                      Colors.tealAccent,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (controller.activeIndex.value == 2) {
                return SizedBox(
                  height: Get.height - 300.h,

                  child: ListView.builder(
                    itemCount: dewormings.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: Get.height - 300.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 10.h,
                        ),
                        child: ListView.builder(
                          itemCount: vaccines.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 20.h,
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
                                  Container(
                                    height: 100.w,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          vaccines[index].image,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: vaccines[index].name,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomText(
                                        text: vaccines[index].description,
                                      ),
                                      CustomText(
                                        text: "From P${vaccines[index].price}",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  GradientButton(
                                    height: 48.h,
                                    text: "Book Now",
                                    onPressed: () {
                                      CustomBottomsheet(
                                        child: Column(),
                                      ).floating();
                                    },
                                    gradientColors: [
                                      Colors.teal,
                                      Colors.tealAccent,
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            }),
          ],
        ),
      ],
    );
  }

  _loading() {
    return const Center(child: Text('Clinics Loaded'));
  }

  _error() {
    return Center(
      child: const Center(child: CustomText(text: 'Error loading clinics')),
    );
  }
}
