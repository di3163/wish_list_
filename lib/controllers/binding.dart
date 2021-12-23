import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';
import 'package:wish_list_gx/utils/cache_manager.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<DataRepositoryInterface>(FirebaseDataRepository());
    Get.put<AuthRepositoryInterface>(FirebaseAuthRepository());
    Get.put<CacheManager>(XCacheManager.instance);
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