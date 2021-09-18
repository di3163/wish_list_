
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
    if (user.userStatus != UserStatus.unauthenticated) {
      listWish.bindStream(_firebaseRepository.getUserWishStream(user.id));
    }else{
      listWish.value.clear();
    }
  }

  // void unbindListWish(){
  //   try {
  //     listWish.refresh();
  //   }catch(e){
  //     print(e.toString());
  //   }
  //   listWish.value = [];
  //}



  @override
  void onClose() {
    listWish.close();
    super.onClose();
  }
}
