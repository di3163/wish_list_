import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class UserController extends GetxController{
  final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
  final userStatus = UserStatus.unauthenticated.obs;
  final formKey = GlobalKey<FormState>().obs;


  Future<void> signIn({required String email, required String pass}) async{
    try {
      await _firebaseRepository.signIn(email: email, password: pass);
      //Get.find<FirebaseRepository>().signIn(email: email, password: pass);
      userStatus.value = UserStatus.authenticated;
    } on Exception{
      userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    userStatus.value = UserStatus.unauthenticated;
    update();
  }

  void _confirmUser(){
    User? user = _firebaseRepository.getCurrentUser();
    //User? user = Get.find<FirebaseRepository>().getCurrentUser();
    if(user != null) userStatus.value = UserStatus.authenticated;
  }

  @override
  void onInit() {
    _confirmUser();
    super.onInit();
  }
}