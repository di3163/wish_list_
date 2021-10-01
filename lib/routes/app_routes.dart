import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';
import 'package:wish_list_gx/views/img_view.dart';


abstract class Routes{
  static const home = '/';
  static const wish = '/wish';
  static const img = '/img';
  const Routes._();
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
        page: () => const WishView(),
        binding: WishBindings(),
    ),
    GetPage(
      name:  Routes.img,
      page: () => ImgView(patch: Get.arguments),
    )
  ];
  const AppPages._();
}
