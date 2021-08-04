import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController{
  UserProfileController(this._firebaseRepository);
  final AuthRepositoryInterface _firebaseRepository;
  //final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
      final userStatus = UserStatus.unauthenticated.obs;
  //final formKey = GlobalKey<FormState>().obs;
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
      userStatus.value = UserStatus.authenticated;
    } on Exception {
      userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signIn({required String email, required String pass}) async{
    try {
      await _firebaseRepository.signIn(email: email, password: pass);
      //Get.find<FirebaseRepository>().signIn(email: email, password: pass);
      userStatus.value = UserStatus.authenticated;
      //Get.find<WishListController>().bindListWish('');
    } on Exception{
      userStatus.value = UserStatus.unauthenticated;
    }
    update();
  }

  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    userStatus.value = UserStatus.unauthenticated;
    update();
  }

  void _confirmUser(){
    User? user = _firebaseRepository.getCurrentUser();
    //User? user = Get.find<FirebaseRepository>().getCurrentUser();
    if(user != null) userStatus.value = UserStatus.authenticated;
  }

  @override
  void onInit() {
    _confirmUser();
    super.onInit();
  }

}