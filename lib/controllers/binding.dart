import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(FirebaseDataRepository());
    Get.put(FirebaseAuthRepository());
    Get.put<HomeController>(HomeController());//1
    Get.put<UserProfileController>(UserProfileController());//2
    Get.put<WishListController>(WishListController());//3
    Get.put<ContactsXController>(ContactsXController());//4
  }
}

class HomeBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}

class WishBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<WishController>(WishController());
  }
}