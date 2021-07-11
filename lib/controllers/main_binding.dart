import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

import '../core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<FirebaseRepository>(FirebaseRepository());
    Get.put<HomeController>(HomeController());
    Get.put<UserController>(UserController());

  }

}