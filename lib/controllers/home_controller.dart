import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';



class HomeController extends GetxController{
  final pageController = PageController();
  //late SharedPreferences _preferences;
  var isVisibleFAB = false.obs;
  var isVisibleSettingCog = true.obs;
  var isThemeLightShampoo = true.obs;
  var isThemeBlackCrows = false.obs;
  //var themeApp = ThemeApp.Shampoo.obs;

  int tabIndex = 0;
  UserApp user = UserEmpty();
  Rx<AppUserWidget> userWidget = Rx<AppUserWidget>(UserWidget());

  void otherUserWishList(UserOther user){
    this.user = user;
    userWidget(OtherUserWidget(user.name));
    Get.find<WishListController>().bindListWish(user);
    //visibleFAB.value = false;
    pageController.jumpToPage(2);
    //update();
  }

  void onChangeTabIndex(int index) {
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
  }

  void onSwitchThemeMode(){
    if(isThemeLightShampoo.value){
      isThemeLightShampoo.value = false;
      isThemeBlackCrows.value = true;
      Get.changeTheme(themeBlackCrows);
      Get.find<UserProfileController>().preferences.setString('theme', 'blackcrows');
      //Get.find<UserProfileController>().renderAvatar();
    } else{
      isThemeLightShampoo.value = true;
      isThemeBlackCrows.value = false;
      Get.changeTheme(themeLightShampoo);
      Get.find<UserProfileController>().preferences.setString('theme', 'lightshampoo');
      //Get.find<UserProfileController>().renderAvatar();
    }
  }

  void onSwitchLocale(){
    if(Get.locale!.languageCode == 'en'){
      Get.updateLocale(const Locale('ru', 'RU'));
      Get.find<UserProfileController>().preferences.setString('locale', 'ru');
      //Get.updateLocale(Locale('ru', 'RU'));
    }else{
      Get.updateLocale(const Locale('en', 'UK'));
      Get.find<UserProfileController>().preferences.setString('locale', 'en');
      //Get.updateLocale(Locale('en', 'UK'));
    }

  }

  // void _setSwitch(){
  //   Get.theme.
  // }

  // void _setPrefLocale(String languageCode){
  //   if(languageCode == 'en'){
  //     Get.updateLocale(Locale('en', 'UK'));
  //   }else{
  //     Get.updateLocale(Locale('ru', 'RU'));
  //   }
  // }

  // void _setPrefTheme(String theme){
  //   if (theme == 'blackcrows'){
  //     Get.changeTheme(themeBlackCrows);
  //     isThemeLightShampoo.value = false;
  //     isThemeBlackCrows.value = true;
  //   }else{
  //     Get.changeTheme(themeLightShampoo);
  //     isThemeLightShampoo.value = true;
  //     isThemeBlackCrows.value = false;
  //   }
  // }

  // _getPreferencesInstance() async {
  //   _preferences = await SharedPreferences.getInstance();
  // }

  // void _initPreferences(){
  //   _setPrefLocale(_preferences.getString('locale') ?? Get.deviceLocale!.languageCode);
  //   _setPrefTheme(_preferences.getString('theme') ?? 'lightshampoo');
  //
  // }


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  @override
  void onInit(){
    user = Get.find<UserProfileController>().user.value;
    // await _getPreferencesInstance();
    // _initPreferences();
    super.onInit();
  }
}