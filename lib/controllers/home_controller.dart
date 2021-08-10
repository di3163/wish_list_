import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  final animationDuration = Duration(milliseconds: 300);
  var visibleFAB = false.obs;
  var tabIndex = 0;
  //Color naviBarItemColor = Colors.blueAccent;

  void otherUserWishList(UserApp userApp){
    Get.find<WishListController>().bindListWish(userApp);
    visibleFAB.value = false;
    pageController.jumpToPage(2);
  }

  void changeTabIndex(int index, UserApp userApp) {
    //tabIndex = index;
    if(index == 2){
      // if(userApp.userStatus == UserStatus.authenticated) {
      //   //naviBarItemColor = Colors.blueAccent;
         visibleFAB.value = true;
      // }else{
      //   //naviBarItemColor = Colors.black12;
      // }
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