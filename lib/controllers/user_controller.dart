import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wish_list_gx/core.dart';

class UserController extends GetxController{
  UserStatus userStatus = UserStatus.unauthenticated;
  final FirebaseRepository firebaseRepository = Get.find();

  @override
  void onInit() {
    User? user = firebaseRepository.getCurrentUser();
    if(user != null) userStatus = UserStatus.authenticated;
    super.onInit();
  }
}