import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';
import 'package:wish_list_gx/views/widgets/user_widgets.dart';

class HomeController extends GetxController{
  final pageController = PageController();
  var isVisibleFAB = false.obs;
  var isVisibleSettingCog = true.obs;
  var isThemeLightShampoo = true.obs;
  var isThemeBlackCrows = false.obs;
  int tabIndex = 0;
  UserApp user = UserEmpty();
  Rx<AppUserWidget> userWidget = Rx<AppUserWidget>(UserWidget());

  //Rx<String> avatarURL = Rx<String>('');

  void otherUserWishList(UserOther user){
    this.user = user;
    userWidget(OtherUserWidget(user.name));
    Get.find<WishListController>().bindListWish(user);
    //visibleFAB.value = false;
    pageController.jumpToPage(2);
    //update();
  }

  void onChangeTabIndex(int index) {
    //avatarURL.value = userApp.photoURL;
    userWidget(UserWidget());
    if (index == 0){
      isVisibleSettingCog.value = true;
    }else {
      isVisibleSettingCog.value = false;
    }
    if(index == 2){
      isVisibleFAB.value = true;
      Get.find<WishListController>().bindListWish(user);
    }else{
      isVisibleFAB.value = false;
    }
    //update();
  }

  void switchThemeMode(){
    if(isThemeLightShampoo.value){
      isThemeLightShampoo.value = false;
      isThemeBlackCrows.value = true;
    } else{
      isThemeLightShampoo.value = true;
      isThemeBlackCrows.value = false;
    }
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