
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishListController extends GetxController{
  WishListController(this._firebaseRepository);
  UserApp user = UserEmpty.empty();
  Rx<WishWidget> currentWishWidget = Rx<WishWidget>(const ErrWishWidget());

  final WishRepositoryInterface _firebaseRepository;
  Rx<List<Wish>> listWish = Rx<List<Wish>>([]);

  void deleteWish(Wish wish){
    for(String imgUrl in wish.listPicURL){
      _firebaseRepository.deleteImage(imgUrl);
    }
    _firebaseRepository.deleteWish(wish);

    // Get.defaultDialog(
    //   title: 'del'.tr,
    //   backgroundColor: Get.theme.backgroundColor,
    //   buttonColor: Get.theme.buttonColor,
    //   onConfirm: () {
    //     for(String imgUrl in wish.listPicURL){
    //       _firebaseRepository.deleteImage(imgUrl);
    //     }
    //     _firebaseRepository.deleteWish(wish);
    //     Get.back();
    //   },
    //   onCancel: () {},
    //   middleText: '',
    //);
  }

  void bindListWish(UserApp user){
    this.user = user;
    if (user.userStatus == UserStatus.other) {
      currentWishWidget(const OtherWishWidget());
    }else{
      currentWishWidget(const UserWishWidget());
    }
    if (user.userStatus != UserStatus.unauthenticated) {
      listWish.bindStream(_firebaseRepository.fetchUserWishStream(user.id));
    }else{
      listWish.value.clear();
    }
  }

  @override
  void onClose() {
    listWish.close();
    super.onClose();
  }
}
