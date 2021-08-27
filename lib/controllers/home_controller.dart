import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  var visibleFAB = false.obs;
  int tabIndex = 0;
  UserApp user = UserEmpty();

  //Rx<String> avatarURL = Rx<String>('');

  void otherUserWishList(UserApp user){
    this.user = user;
    Get.find<WishListController>().bindListWish(user);
    //visibleFAB.value = false;
    pageController.jumpToPage(2);
    //update();
  }

  void onChangeTabIndex(int index) {
    //avatarURL.value = userApp.photoURL;
    if(index == 2){
      visibleFAB.value = true;
      Get.find<WishListController>().bindListWish(user);
    }else{
      visibleFAB.value = false;
    }
    //update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  void onInit(){
    user = Get.find<UserProfileController>().user.value;
    super.onInit();
  }
}