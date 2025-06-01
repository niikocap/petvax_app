import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/components/appointments_section.dart';
import 'package:petvax/app/widgets/custom_text.dart';

import '../../../app/components/custom_menu.dart';
import 'appointments_cb.dart';

class Appointments extends GetView<AppointmentsController> {
  const Appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            AppointmentsView.loading => _loading(),
            AppointmentsView.loaded => _loaded(),
            AppointmentsView.error => _error(),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF9333EA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: "Appointments",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(6.5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.white,
                            ),
                            child: Icon(Icons.filter_list, size: 20.sp),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(6.5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.teal,
                            ),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: controller.searchQuery,
                    onChanged: (val) {
                      //todo search
                    },
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                      ),
                      hintText: "Search appointments...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => AppointmentsSection(
              appointments: controller.appointments.value,
              axis: Axis.vertical,
              height: Get.height - 160.h,
              showHeader: false,
            ),
          ),
        ],
      ),
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
