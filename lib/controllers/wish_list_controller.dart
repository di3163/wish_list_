
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class WishListController extends GetxController{

  UserApp user = UserEmpty.empty();
  Rx<WishWidget> currentWishWidget = Rx<WishWidget>(const ErrWishWidget());

  late final DataRepositoryInterface _dataRepository;
  Rx<List<Wish>> listWish = Rx<List<Wish>>([]);

  void deleteWish(Wish wish){
    for(String imgUrl in wish.listPicURL){
      _dataRepository.deleteImage(imgUrl);
    }
    _dataRepository.deleteWish(wish);
  }

  void clearListWish(){
    listWish.value.clear();
    //listWish.close();

  }

  // Future<String> cachedUrl(String sourseUrl)async{
  //   var fetchedFile = await DefaultCacheManager().getSingleFile(sourseUrl);
  //   return fetchedFile.path;
  // }

  void bindListWish(UserApp user){
    this.user = user;
    if (user.userStatus == UserStatus.other) {
      currentWishWidget(const OtherWishWidget());
    }else{
      currentWishWidget(const UserWishWidget());
    }
    if (user.userStatus != UserStatus.unauthenticated) {
      listWish.bindStream(_dataRepository.fetchUserWishStream(user.id));
    }else{
      listWish.value.clear();
    }
  }

  @override
  void onInit(){
    _dataRepository = Get.find<DataRepositoryInterface>();
    super.onInit();
  }

  @override
  void onClose() {
    listWish.close();
    super.onClose();
  }
}
