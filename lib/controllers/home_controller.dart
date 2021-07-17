import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  final animationDuration = Duration(milliseconds: 300);
  var visibleFAB = false.obs;
  var tabIndex = 0;

  void changeTabIndex(int index) {
    //tabIndex = index;
    if(index == 2){
      visibleFAB.value = true;
    }else{
      visibleFAB.value = false;
    }
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}