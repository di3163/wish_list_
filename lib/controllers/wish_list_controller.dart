
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishListController extends GetxController{

  Rx<List<Wish>> listWish = Rx<List<Wish>>([]);

  @override
  void onInit() {
    super.onInit();
    listWish.value = MockWish().getWishList();
    //currentWish = listWish.value[0];
  }

  @override
  void dispose() {
    super.dispose();
  }


}
