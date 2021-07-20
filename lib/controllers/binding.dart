import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

import '../core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<FirebaseRepository>(FirebaseRepository());
    Get.put<HomeController>(HomeController());
    Get.put<UserProfileController>(UserProfileController());
    Get.put<WishListController>(WishListController());
  }
}

class WishBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<WishController>(WishController());
  }

}