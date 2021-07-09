import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<FirebaseRepository>(FirebaseRepository());
  }

}