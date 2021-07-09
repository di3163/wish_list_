import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';


abstract class Routes{
  static const HOME = '/';
}

class AppPages{
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      //binding: HomeBinding(),
    ),
  ];
}
