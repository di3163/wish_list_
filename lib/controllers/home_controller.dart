import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_gx/core.dart';



class HomeController extends GetxController{
  final pageController = PageController();
  late SharedPreferences preferences;
  var isVisibleFAB = false.obs;
  var isVisibleSettingCog = true.obs;
  var isThemeBlackCrows = false.obs;

  int tabIndex = 0;
  UserApp user = UserEmpty.empty();
  Rx<AppUserWidget> userWidget = Rx<AppUserWidget>(UserWidget());

  void otherUserWishList(UserOther user){
    this.user = user;
    userWidget(OtherUserWidget(user.name));
    Get.find<WishListController>().bindListWish(user);
    pageController.jumpToPage(2);

  }

  void onChangeTabIndex(int index) {
    userWidget(UserWidget());
    if (index == 0){
      isVisibleSettingCog.value = true;
    }else {
      isVisibleSettingCog.value = false;
    }
    // if(index == 1){
    //   Get.find<ContactsXController>().updateContactWidget();
    // }
    if(index == 2){
      isVisibleFAB.value = true;
      Get.find<WishListController>().bindListWish(user);
    }else{
      isVisibleFAB.value = false;
    }
  }

  void onSwitchThemeMode(){
    if(!isThemeBlackCrows.value){
      isThemeBlackCrows.value = true;
      Get.changeTheme(themeBlackCrows);
      Get.find<UserProfileController>().preferences.setString('theme', 'blackcrows');
    } else{
      isThemeBlackCrows.value = false;
      Get.changeTheme(themeLightShampoo);
      Get.find<UserProfileController>().preferences.setString('theme', 'lightshampoo');
    }
  }

  void onSwitchLocale(){
    var locale = Get.locale;
    if(locale!.languageCode == 'en'){
      Get.updateLocale(const Locale('ru', 'RU'));
      Get.find<UserProfileController>().preferences.setString('locale', 'ru');
    }else{
      Get.updateLocale(const Locale('en', 'UK'));
      Get.find<UserProfileController>().preferences.setString('locale', 'en');
    }

  }


  void _setThemeSwitch(){
    String themeApp = preferences.getString('theme') ?? 'lightshampoo';
    if (themeApp == 'lightshampoo'){
      isThemeBlackCrows.value = false;
    }else{
      isThemeBlackCrows.value = true;
    }
  }

  _getPreferencesInstance() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  void onInit()async{
    await _getPreferencesInstance();
    user = Get.find<UserProfileController>().user.value;
    _setThemeSwitch();
    super.onInit();
  }
}