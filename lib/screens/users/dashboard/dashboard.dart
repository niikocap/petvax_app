import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/components/appointments_section.dart';
import 'package:petvax/app/components/clinics_section.dart';

import '../../../app/components/custom_menu.dart';
import '../../../app/widgets/custom_text.dart';
import 'dashboard_cb.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Obx(
          () => switch (controller.view.value) {
            DashboardView.loaded => _loaded(),
            DashboardView.loading => Center(child: CircularProgressIndicator()),
            DashboardView.error => Center(child: CustomText(text: "App Error")),
          },
        ),
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _loaded() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchAppointments();
        await controller.fetchPets();
        await controller.fetchClinics();
      },
      child: Column(
        children: [
          // Header Section
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
                CustomText(
                  text: "PetVax Dashboard",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: "Search clinics...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Clinics Section
                  Obx(
                    () => ClinicsSection(
                      clinics: controller.clinics.value,
                      padding: 0,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Pets Section
                  _buildPetsSection(controller),
                  SizedBox(height: 24.h),

                  // Appointments Section
                  Obx(
                    () => AppointmentsSection(
                      appointments: controller.appointments.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsSection(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "My Pets",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/pets');
                },
                child: CustomText(
                  text: "View All",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Horizontal Scrollable Pets
          SizedBox(
            height: 75.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.pets.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.pets.length) {
                  // Add Pet Card
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/add-pet');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD1D5DB),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "Add Pet",
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final pet = controller.pets[index];
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: pet.name[0].toUpperCase(),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: pet.name,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F2937),
                          ),
                          CustomText(
                            text: pet.species,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
