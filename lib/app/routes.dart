import 'package:get/get.dart';
import 'package:petvax/screens/all/auth/auth.dart';
import 'package:petvax/screens/all/auth/auth_cb.dart';
import 'package:petvax/screens/all/profile/profile.dart';
import 'package:petvax/screens/all/profile/profile_cb.dart';
import 'package:petvax/screens/users/appointments/appointments.dart';
import 'package:petvax/screens/users/appointments/appointments_cb.dart';
import 'package:petvax/screens/users/clinics/clinic_cb.dart';
import 'package:petvax/screens/users/clinics/services.dart';
import 'package:petvax/screens/users/clinics/services_cb.dart';
import 'package:petvax/screens/users/dashboard/dashboard.dart';
import 'package:petvax/screens/users/dashboard/dashboard_cb.dart';
import 'package:petvax/screens/users/pets/add_pets.dart';
import 'package:petvax/screens/users/pets/cb/pets_cb.dart';

import '../screens/users/clinics/clinics.dart';
import '../screens/users/pets/cb/add_pet_cb.dart';
import '../screens/users/pets/pets.dart';

appRoutes() => [
  GetPage(name: '/auth', page: () => AuthScreen(), binding: AuthBinding()),
  GetPage(
    name: '/home',
    page: () => DashboardScreen(),
    binding: DashboardBinding(),
  ),
  GetPage(name: '/pets', page: () => Pets(), binding: PetsBinding()),
  GetPage(
    name: '/add-pet',
    page: () => AddPetScreen(),
    binding: AddPetBinding(),
  ),
  GetPage(name: '/clinics', page: () => Clinics(), binding: ClinicsBinding()),
  GetPage(
    name: '/appointments',
    page: () => Appointments(),
    binding: AppointmentsBinding(),
  ),
  GetPage(
    name: '/services',
    page: () => Services(),
    binding: ServicesBinding(),
  ),
  GetPage(
    name: '/profile',
    page: () => PetOwnerProfileScreen(),
    binding: PetOwnerBinding(),
  ),
];
