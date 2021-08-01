import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  final animationDuration = Duration(milliseconds: 300);
  var visibleFAB = false.obs;
  var tabIndex = 0;

  void changeTabIndex(int index) {
    //tabIndex = index;
    if(index == 2){
      visibleFAB.value = true;
      Get.find<WishListController>().bindListWish('');
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