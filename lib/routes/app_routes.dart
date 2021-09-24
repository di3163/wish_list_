import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';


abstract class Routes{
  static const home = '/';
  static const wish = '/wish';
}

class AppPages{
  static const initial = Routes.home;
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      //binding: HomeBinding(),
    ),
    GetPage(
        name: Routes.wish,
        page: () => WishView(),
        binding: WishBindings(),
    ),
  ];
}
