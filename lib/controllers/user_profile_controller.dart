
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController{

  UserProfileController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  //UserApp user;
  Rx<UserApp> user = Rx<UserApp>(UserEmpty());
  //final user = UserFirebase(id: '', userStatus: UserStatus.unauthenticated).obs;

  //final userStatus = UserStatus.unauthenticated.obs;
  //Rx<UserStatus> userStatus = user.userStatus.obs;

  final formType = FormType.login.obs;

  void switchForm(){
    formType.value =
    formType.value == FormType.login ? FormType.register : FormType.login;
    update();
  }

  Future<void> signUp({required String email, required String pass, required String phone}) async{
    try{
      //TODO для Андроид добавить нативное получение своего номера
      await _firebaseRepository.signUp(email: email, password: pass, phone: phone);
      _confirmUser();
      _getUserContact();
      //userStatus.value = UserStatus.authenticated;
      //user.value.userStatus = UserStatus.authenticated;
    } on Exception {
      user.value = UserEmpty();
      //user.value = UserFirebase(id: '', userStatus:  UserStatus.unauthenticated);
      //userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signIn({required String email, required String pass}) async{
    try {
      await _firebaseRepository.signIn(email: email, password: pass);
      _confirmUser();
      _getUserContact();
      //Get.find<FirebaseRepository>().signIn(email: email, password: pass);
      //userStatus.value = UserStatus.authenticated;
      //Get.find<WishListController>().bindListWish('');
    } on Exception{
      //user.value = UserFirebase(id: '', userStatus:  UserStatus.unauthenticated);
      user.value = UserEmpty();
    }
    update();
  }

  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    Get.delete<WishListController>();
    Get.lazyPut<WishListController>(() => WishListController(FirebaseWishRepository()));
    user.value = UserEmpty();
    _getUserContact();
    update();
  }

  void _confirmUser(){
    user.value = UserFirebase.fromFirebaseUser(_firebaseRepository.getCurrentUser());
    //Get.put<WishListController>(WishListController(FirebaseWishRepository()));
  }

  void _getUserContact(){
    Get.find<ContactsXController>().getContacts();
  }

  @override
  void onInit() {
    _confirmUser();
    super.onInit();
  }

}