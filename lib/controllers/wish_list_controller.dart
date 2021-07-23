
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishListController extends GetxController{
  final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
  Rx<List<Wish>> listWish = Rx<List<Wish>>([]);

  @override
  void onInit() async{
    super.onInit();
    //listWish.value = await _firebaseRepository.getUserWish();
    listWish.bindStream(_firebaseRepository.getUserWishStream());
    //listWish.value = MockWish().getWishList();
  }

  // @override
  // void dispose() {
  //   listWish.close();
  //   super.dispose();
  // }

  @override
  void onClose() {
    listWish.close();
    super.onClose();
  }
}
