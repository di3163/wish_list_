
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController{

  UserProfileController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  //UserApp user;
  //Rx<UserApp> user = Rx<UserApp>(UserFirebase(id: '', userStatus: UserStatus.unauthenticated));
  final user = UserFirebase(id: '', userStatus: UserStatus.unauthenticated).obs;

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
      //userStatus.value = UserStatus.authenticated;
      //user.value.userStatus = UserStatus.authenticated;
    } on Exception {
      user.value = UserFirebase(id: '', userStatus:  UserStatus.unauthenticated);
      //userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signIn({required String email, required String pass}) async{
    try {
      await _firebaseRepository.signIn(email: email, password: pass);
      _confirmUser();
      //Get.find<FirebaseRepository>().signIn(email: email, password: pass);
      //userStatus.value = UserStatus.authenticated;
      //Get.find<WishListController>().bindListWish('');
    } on Exception{
      user.value = UserFirebase(id: '', userStatus:  UserStatus.unauthenticated);
      //userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    user.value = UserFirebase(id: '', userStatus:  UserStatus.unauthenticated);
    //userStatus.value = UserStatus.unauthenticated;
    update();
  }

  void _confirmUser(){
    user.value = UserFirebase.fromFirebaseUser(_firebaseRepository.getCurrentUser());
    //User? user = _firebaseRepository.getCurrentUser();
    //User? user = Get.find<FirebaseRepository>().getCurrentUser();
    //if(user != null) userStatus.value = UserStatus.authenticated;
  }

  @override
  void onInit() {
    _confirmUser();
    super.onInit();
  }

}