import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/repository/firebase_data_repository.dart';
import 'package:wish_list_gx/core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<UserProfileController>(UserProfileController(FirebaseAuthRepository()));
    Get.put<WishListController>(WishListController(FirebaseDataRepository()));
    Get.put<ContactsXController>(ContactsXController(FirebaseAuthRepository()));
  }
}

class WishBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<WishController>(WishController(FirebaseDataRepository(), ImagePicker()));
  }

}