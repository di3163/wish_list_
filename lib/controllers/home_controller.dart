import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  var visibleFAB = false.obs;
  int tabIndex = 0;

  void otherUserWishList(UserApp userApp){
    Get.find<WishListController>().bindListWish(userApp);
    visibleFAB.value = false;
    pageController.jumpToPage(2);
  }

  void changeTabIndex(int index, UserApp userApp) {
    if(index == 2){
      visibleFAB.value = true;
      Get.find<WishListController>().bindListWish(userApp);
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