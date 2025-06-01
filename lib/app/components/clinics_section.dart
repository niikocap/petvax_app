import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/clinic_model.dart';
import '../widgets/custom_text.dart';

class ClinicsSection extends StatelessWidget {
  final List<Clinic> clinics;
  final Axis? axis;
  final double? height;
  final bool showHeader;
  final double? padding;

  const ClinicsSection({
    super.key,
    required this.clinics,
    this.axis,
    this.height,
    this.showHeader = true,
    this.padding,
  });

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding ?? 16.w),
      child: Column(
        children: [
          showHeader
              ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Nearby Clinics",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/clinics',
                            arguments: {'search_param': ''},
                          );
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
                  SizedBox(height: 10.h),
                ],
              )
              : Container(),
          SizedBox(
            height: height ?? 235.h,
            child: ListView.builder(
              scrollDirection: axis ?? Axis.horizontal,
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                return Column(
                  children: [
                    Container(
                      width: height == null ? 280.w : double.infinity,
                      margin: EdgeInsets.only(
                        right: height != null ? 0 : 16.w,
                        bottom: height == null ? 0 : 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.r),
                            ),
                            child: Image.network(
                              clinic.image,
                              height: height == null ? 100.h : 125.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100.h,
                                  width: Get.width,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Content
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: clinic.name,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.w),
                                        SizedBox(
                                          width: Get.width - 170.w,
                                          child: CustomText(
                                            text: clinic.location,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var pos = await determinePosition();
                                        final Uri googleMapsUrl = Uri.parse(
                                          'https://www.google.com/maps/dir/?api=1&origin=${pos.latitude},${pos.longitude}&destination=${clinic.latitude},${clinic.longitude}&travelmode=driving',
                                        );

                                        await launchUrl(
                                          googleMapsUrl,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                      child: Icon(
                                        Icons.directions,
                                        size: 25.sp,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 12,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            "${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(clinic.openingTime))} - ${DateFormat('h:mm a').format(DateFormat('HH:mm').parse(clinic.closingTime))}",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: "${clinic.distance} away",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF2563EB),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          '/services',
                                          arguments: clinic,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2563EB),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: CustomText(
                                          text: "View",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
