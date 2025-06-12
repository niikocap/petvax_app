// Dependencies to add in pubspec.yaml:
// dependencies:
//   flutter_screenutil: ^5.9.0
//   get: ^4.6.6
//   google_fonts: ^6.1.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petvax/app/components/custom_menu.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/screens/all/profile/profile_cb.dart';

// Main Screen
class PetOwnerProfileScreen extends GetView<PetOwnerController> {
  const PetOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(
        () => switch (controller.view.value) {
          ProfileView.loading => Center(child: CircularProgressIndicator()),
          ProfileView.loaded => SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildActionButtons(),
                _buildContactInfo(),
                _buildTabs(),
                Obx(
                  () =>
                      controller.activeTab.value == 'pets'
                          ? _buildPetsList()
                          : _buildFavorites(),
                ),
              ],
            ),
          ),
          ProfileView.error => Center(child: Text('Failed to load profile')),
        },
      ),
      floatingActionButton: CustomMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade500, Colors.purple.shade600],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
          child: Column(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () async {
                          await Storage.deleteUser();
                          Get.offAndToNamed('/auth');
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Profile Info
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 4.w,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(controller.user!.avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -4.h,
                        right: -4.w,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 16.w,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.user!.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white.withOpacity(0.8),
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              controller.user!.address,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Stats
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'tempo: 0',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Bookings',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${controller.pets.length}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'My Pets',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Transform.translate(
      offset: Offset(0, -24.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: controller.editProfile,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.blue.shade600,
                          size: 16.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.poppins(
                            color: Colors.blue.shade600,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: controller.viewBookings,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.purple.shade600,
                          size: 16.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'My Bookings',
                          style: GoogleFonts.poppins(
                            color: Colors.purple.shade600,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade900,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.green.shade600,
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      controller.user!.phone,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.email,
                    color: Colors.blue.shade600,
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      controller.user!.email,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab('pets'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color:
                          controller.activeTab.value == 'pets'
                              ? Colors.white
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow:
                          controller.activeTab.value == 'pets'
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Text(
                      'My Pets (${controller.pets.length})',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color:
                            controller.activeTab.value == 'pets'
                                ? Colors.grey.shade900
                                : Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab('favorites'),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color:
                          controller.activeTab.value == 'favorites'
                              ? Colors.white
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow:
                          controller.activeTab.value == 'favorites'
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Text(
                      'Favorites',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color:
                            controller.activeTab.value == 'favorites'
                                ? Colors.grey.shade900
                                : Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Pets',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade900,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: controller.addPet,
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.blue.shade600, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(
                      'Add Pet',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.shade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.pets.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final pet = controller.pets[index];
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: NetworkImage(pet.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pet.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade900,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.editPet(pet),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey.shade400,
                                  size: 16.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${pet.type} • ${pet.age}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Vaccinated',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Last booking: ${pet.lastBooking}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Column(
        children: [
          Icon(Icons.favorite_border, color: Colors.grey.shade300, size: 48.w),
          SizedBox(height: 16.h),
          Text(
            'No favorites yet',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade900,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start adding your favorite pet sitters and services',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
