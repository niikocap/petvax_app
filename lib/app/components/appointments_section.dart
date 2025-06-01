import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petvax/app/models/appointment_model.dart';

import '../../screens/users/appointments/appointments_cb.dart';
import '../constants/strings.dart';
import '../widgets/custom_text.dart';

class AppointmentsSection extends StatelessWidget {
  final List<Appointment> appointments;
  final Axis? axis;
  final double? height;
  final bool showHeader;
  const AppointmentsSection({
    super.key,
    required this.appointments,
    this.axis,
    this.showHeader = true,
    this.height,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'completed':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFDCFCE7);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'completed':
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      [const Color(0xFF3B82F6), const Color(0xFF9333EA)],
      [const Color(0xFF10B981), const Color(0xFF059669)],
      [const Color(0xFFEC4899), const Color(0xFFDC2626)],
    ];

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
          showHeader
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Recent Appointments",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/appointments');
                    },
                    child: CustomText(
                      text: "View All",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ],
              )
              : Container(),
          SizedBox(height: 16.h),

          // Appointments List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final colors = gradientColors[index % gradientColors.length];

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    // Colored Header
                    Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date, Status, and Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: appointment.date,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusBackgroundColor(
                                            appointment.status,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: CustomText(
                                          text: appointment.status,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: getStatusColor(
                                            appointment.status,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  appointment.status.toLowerCase().contains(
                                        'pending',
                                      )
                                      ? Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          GestureDetector(
                                            onTap: () async {
                                              var res = await GetConnect().get(
                                                '${AppStrings.baseUrl}booking/update/${appointment.id}/cancelled',
                                              );
                                              print(res.body);
                                              if (res.body['status'] ==
                                                  "success") {
                                                Get.snackbar(
                                                  "Success",
                                                  "Appointment cancelled successfully",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green
                                                      .withOpacity(0.1),
                                                  colorText: Colors.green,
                                                );
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Failed to cancel appointment",
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.1),
                                                  colorText: Colors.red,
                                                );
                                              }
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 22.sp,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Clinic
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Clinic",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B7280),
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                text: appointment.clinicName,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F2937),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Service and Pet
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Service",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: appointment.serviceName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Pet",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF6B7280),
                                    ),
                                    SizedBox(height: 2.h),
                                    CustomText(
                                      text: appointment.petName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Amount and View Details
                          Container(
                            padding: EdgeInsets.only(top: 12.h),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xFFF3F4F6)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: appointment.amount,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: CustomText(
                                        text: "View Details",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    appointment.status.toLowerCase().contains(
                                          "completed",
                                        )
                                        ? GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 2.5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                            child: CustomText(
                                              text: "Rate",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        )
                                        : Container(),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }

  // Add these methods to handle the actions
  void _editAppointment(appointment) {
    // Navigate to edit appointment screen or show edit dialog
    // Example:
    Get.toNamed('/edit-appointment', arguments: appointment);

    // Or show a bottom sheet/dialog
    // showEditAppointmentDialog(appointment);
  }

  void _deleteAppointment(appointment, int index) {
    // Show confirmation dialog before deleting
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Appointment'),
        content: const Text(
          'Are you sure you want to delete this appointment?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // Remove from list and update UI
              appointments.removeAt(index);
              Get.back();
              // You might also want to call an API to delete from backend
              _deleteAppointmentFromBackend(appointment.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewAppointmentDetails(appointment) {
    // Handle view details
    Get.toNamed('/appointment-details', arguments: appointment);
  }

  void _deleteAppointmentFromBackend(String appointmentId) {
    // API call to delete appointment from backend
    // Example:
    // appointmentService.deleteAppointment(appointmentId);
  }
}
