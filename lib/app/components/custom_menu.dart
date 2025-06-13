import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      radius: 90,
      toggleButtonSize: 30,

      items: [
        CircularMenuItem(
          color: Colors.deepPurple,
          iconSize: 25,
          icon: Icons.home,
          onTap: () {
            // Get.offUntil(, predicate)
            Get.toNamed('/home');
          },
        ),
        CircularMenuItem(
          color: Colors.amber,
          iconSize: 25,
          icon: Icons.calendar_month_rounded,
          onTap: () {
            Get.toNamed('/appointments');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.settings,
          color: Colors.pinkAccent,
          onTap: () {
            Get.toNamed('/rule-base');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.pets,
          color: Colors.pink,
          onTap: () {
            Get.toNamed('/pets');
          },
        ),
        CircularMenuItem(
          iconSize: 25,
          icon: Icons.person,
          color: Colors.green,
          onTap: () {
            Get.toNamed('/profile');

            //Get.toNamed('/profile');
          },
        ),
      ],
    );
  }
}
