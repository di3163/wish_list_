
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishListController extends GetxController{
  WishListController(this._firebaseRepository);
  UserApp user = UserEmpty();

  final WishRepositoryInterface _firebaseRepository;
  Rx<List<Wish>> listWish = Rx<List<Wish>>([]);

  void deleteWish(Wish wish){
    Get.defaultDialog(
      title: 'Удалить?',
      onConfirm: () {
        for(String imgUrl in wish.listPicURL){
          _firebaseRepository.deleteImage(imgUrl);
        }
        _firebaseRepository.deleteWish(wish);
        Get.back();
      },
      onCancel: () {},
      middleText: '',
    );
  }

  void bindListWish(UserApp user){
    this.user = user;
    if (user.userStatus != UserStatus.unauthenticated)
    listWish.bindStream(_firebaseRepository.getUserWishStream(user.id));
  }

  @override
  void onInit() async{
    //listWish.value = await _firebaseRepository.getUserWish();
    // if (Get.find<UserProfileController>().userStatus == UserStatus.authenticated)
    //   bindListWish();
    super.onInit();
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
