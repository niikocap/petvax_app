import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/mixins/snackbar.dart';
import 'package:petvax/app/models/clinic_model.dart';
import 'package:petvax/app/services/storage_service.dart';
import 'package:petvax/app/widgets/gradient_button.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/models/pet_model.dart';
import '../../../app/models/services.dart';

enum ServicesView { loading, loaded, error }

class ServicesController extends GetxController with SnackBarMixin {
  var view = ServicesView.loading.obs;
  GetConnect connect = GetConnect();
  RxString selectedPet = ''.obs;
  RxInt activeIndex = 0.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt selectedHour = 8.obs;
  RxString selectedAmPm = "AM".obs;
  RxBool isDateAvailable = true.obs;
  RxList<Map<String, dynamic>> availableSlots = <Map<String, dynamic>>[].obs;
  RxList<String> shownTime = <String>[].obs;
  var selectedPaymentMethod = "gcash".obs;

  Clinic? clinic;
  List<ServicesModel> services = [];
  List<Pet> pets = [];
  @override
  void onInit() async {
    clinic = Get.arguments;
    connect.baseUrl = AppStrings.baseUrl;
    await loadServices(clinicId: clinic!.id);

    await loadPets(owner: (await Storage.getString(key: 'userId')).toString());

    view(ServicesView.loaded);
    super.onInit();
  }

  loadServices({clinicId}) async {
    var res = await connect.get('service/clinic/$clinicId');
    if (res.status.hasError) {
      showErrorSnackbar("Failed to fetch services: ${res.statusText}");
    } else {
      var data = res.body['data'] as List;
      services = data.map((e) => ServicesModel.fromJson(e)).toList();
    }
  }

  loadServicesTime(id) async {
    availableSlots.clear();
    shownTime.clear();
    var res = await connect.post('check-schedule', {
      "clinic_id": clinic!.id,
      "service_id": id,
      "day": DateFormat('EEEE').format(selectedDate.value).toLowerCase(),
    });

    print(res.body['data']);

    var data =
        res.body['data'].runtimeType == String
            ? jsonDecode(res.body['data'] ?? "[]")
            : res.body['data'] ?? [];

    for (var slot in data) {
      var splitedSlot = slot.split(" ");
      String time = splitedSlot[0];
      bool isAM = splitedSlot[1] == "AM";
      Map<String, dynamic> newSlot = {'time': time, 'isAM': isAM};

      availableSlots.add(newSlot);
    }

    showTime(isAm: selectedAmPm.value == "AM");
  }

  loadPets({owner}) async {
    var res = await connect.get(
      'pet/owner/${await Storage.getString(key: 'userId')}',
    );
    print(res.body);
    pets = res.body['data'].map<Pet>((e) => Pet.fromJson(e)).toList();
    if (pets.isNotEmpty) selectedPet(pets.map((e) => e.name).toList()[0]);
  }

  bookNow(id, amount) async {
    var body = {
      "clinic_id": clinic!.id,
      "service_id": id,
      "pet_id":
          pets
              .firstWhere(
                (e) => e.name.toLowerCase() == selectedPet.value.toLowerCase(),
              )
              .id,
      "client_id": await Storage.getString(key: 'userId'),
      "staff_id": null,
      "appointment_datetime":
          DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            selectedAmPm.value == "PM"
                ? selectedHour.value + 12
                : selectedHour.value,
          ).toIso8601String(),
      "notes": "any",
      "total_amount": amount,
      "status": "pending",
    };
    var res = await connect.post('booking/add', body);

    if (res.body['status'] == 'success') {
      showSuccessSnackBar("Booking has been scheduled!");
    } else {
      showErrorSnackbar("Something went wrong, try again or contact admin!");
    }
  }

  book(id, price) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await loadServicesTime(id);
    Get.back();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Book Appointment",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 5.h),
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.teal),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Select your preferred date and time for the appointment",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.teal, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  "Select Time",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 0.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.teal.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: shownTime.isNotEmpty ? shownTime[0] : null,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.teal,
                          ),
                          items:
                              shownTime
                                  .map(
                                    (time) => DropdownMenuItem(
                                      value: time,
                                      child: Text(
                                        time,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) async {
                            if (value != null) {
                              selectedHour.value = int.parse(
                                value.split(':')[0],
                              );
                              await checkSlots();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 0.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.teal.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedAmPm.value,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.teal,
                          ),
                          items:
                              ['AM', 'PM']
                                  .map(
                                    (period) => DropdownMenuItem(
                                      value: period,
                                      child: Text(
                                        period,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) async {
                            showTime(isAm: value == "AM");
                            selectedAmPm.value = value!;
                            await checkSlots();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.teal, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  "Select Date",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 120)),
                  focusedDay: selectedDate.value,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate.value, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    selectedDate.value = selectedDay;
                    await loadServicesTime(id);
                    await checkSlots();
                  },
                  calendarFormat: CalendarFormat.twoWeeks,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    cellMargin: EdgeInsets.all(4),
                    cellPadding: EdgeInsets.all(4),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekHeight: 45.h,
                  rowHeight: 45.h,
                ),
              ),
            ),

            SizedBox(height: 15.h),
            Obx(
              () => Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color:
                      isDateAvailable.value
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDateAvailable.value ? Icons.check_circle : Icons.cancel,
                      color: isDateAvailable.value ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      isDateAvailable.value
                          ? "Time slot available"
                          : "Time slot not available",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color:
                            isDateAvailable.value ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            GradientButton(
              text: "Confirm Booking",
              onPressed: () {
                if (isDateAvailable.value) {
                  Get.bottomSheet(
                    Container(
                      height: Get.height * 0.6,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Confirm Booking Details",
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.teal.withOpacity(0.3),
                              ),
                            ),
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedPet.value,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.teal,
                                  ),
                                  items:
                                      pets
                                          .map(
                                            (pet) => DropdownMenuItem(
                                              value: pet.name,
                                              child: Text(
                                                pet.name,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    selectedPet.value = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date:",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(selectedDate.value),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time:",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      "${selectedHour.value}:00 ${selectedAmPm.value}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Payment Method",
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.teal.withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Radio(
                                      value: 'cash',
                                      groupValue: selectedPaymentMethod.value,
                                      onChanged: (value) {
                                        selectedPaymentMethod.value = value!;
                                      },
                                      activeColor: Colors.teal,
                                    ),
                                    title: Text(
                                      'Cash',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.money,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    leading: Radio(
                                      value: 'gcash',
                                      groupValue: selectedPaymentMethod.value,
                                      onChanged: (value) {
                                        selectedPaymentMethod.value = value!;
                                      },
                                      activeColor: Colors.teal,
                                    ),
                                    title: Text(
                                      'GCash',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GradientButton(
                            text: "Proceed with Booking",
                            onPressed: () {
                              Get.back();
                              bookNow(id, price);
                            },
                            gradientColors: [Colors.teal, Colors.tealAccent],
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                  //Get.back();
                } else {
                  showErrorSnackbar("Please select an available date and time");
                }
              },
              gradientColors: [Colors.teal, Colors.tealAccent],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  checkSlots() async {
    var res = await connect.post('check-slot', {
      "clinic_id": clinic!.id,
      "service_id": services[activeIndex.value].id,
      "time": "${selectedHour.value}:00 ${selectedAmPm.value}",
      "date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
    });

    print(res.body);
    if (res.body['status'] == 'success') {
      isDateAvailable.value = res.body['available'];
    } else {
      isDateAvailable.value = false;
    }
  }

  showTime({isAm = true}) {
    shownTime.value =
        availableSlots
            .where((slot) => slot['isAM'] == isAm)
            .map((slot) => slot['time'] as String)
            .toList();
  }
}

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicesController>(() => ServicesController());
  }
}
