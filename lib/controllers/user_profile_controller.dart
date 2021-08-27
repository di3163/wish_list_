
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController{

  UserProfileController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;

  Rx<UserApp> user = Rx<UserApp>(UserEmpty());
  Rx<String> avatarURL = Rx<String>('');

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
    } on Exception {
      user.value = UserEmpty();
    }
    update();
  }

  Future<void> signIn({required String email, required String pass}) async{
    try {
      await _firebaseRepository.signIn(email: email, password: pass);
      _confirmUser();
      _getUserContact();
    } on Exception{
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
    avatarURL.value = user.value.photoURL;
  }

  void _getUserContact(){
    Get.find<ContactsXController>().getContacts();
  }

  void addAvatar()async{
    final XFile?  pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedFile != null){
      if(user.value.photoURL.isNotEmpty) {
        await _firebaseRepository.deleteImage(user.value.photoURL);
      }
      String photoURL = await _firebaseRepository.saveImage(File(pickedFile.path));
      await _firebaseRepository.updateUserProfile(photoURL);
      avatarURL.value = photoURL;
    }
  }



  // void _deleteImageFromCache(String imgURL){
  //   try {
  //     CachedNetworkImage.evictFromCache(imgURL);
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }
  

  @override
  void onInit() {
    _confirmUser();
    super.onInit();
  }

}