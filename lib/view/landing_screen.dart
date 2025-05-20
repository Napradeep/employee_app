import 'dart:developer';

import 'package:employe_task/const.dart';
import 'package:employe_task/utlis/dio/dio.dart';
import 'package:employe_task/utlis/spacer/spacer.dart';
import 'package:employe_task/view/auth_screen.dart';
import 'package:employe_task/widget/appbar.dart';
import 'package:employe_task/widget/profile_container.dart';
import 'package:flutter/material.dart';

class CommonScreen extends StatefulWidget {
  const CommonScreen({super.key});

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Column(
        children: [
          vSpace36,
          //logo
          Image.asset("assets/splashimage.jpg", width: 250, height: 200),
          vSpace36,
          //Admin
          ProfileAvatar(
            name: 'ADMIN',
            imagePath: admiImage,
            onTap: () {
              log("ADMIN");
              MyRouter.push(screen: AuthScreen(role: 'ADMIN'));
            },
          ),
          vSpace36,
          // user
          ProfileAvatar(
            name: 'EMPLOYEE',
            imagePath: userIMage,
            onTap: () {
              log("USER");
              MyRouter.push(screen: AuthScreen(role: 'USER'));
            },
          ),
        ],
      ),
    );
  }
}
