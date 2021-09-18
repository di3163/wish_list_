import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';
import 'package:wish_list_gx/repository/firebase_repository_x.dart';

import '../core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    //Get.put<FirebaseRepository>(FirebaseRepository());

    Get.put<UserProfileController>(UserProfileController(
        FirebaseAuthRepository()
      )
    );
    Get.put<HomeController>(HomeController());
    Get.put<WishListController>(WishListController(FirebaseWishRepository()));
    Get.put<ContactsXController>(ContactsXController(FirebaseAuthRepository()));
  }
}

class WishBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<WishController>(WishController(FirebaseWishRepository()));
  }

}