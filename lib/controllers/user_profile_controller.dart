
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController{

  UserProfileController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  late SharedPreferences preferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController formControllerEmail = TextEditingController();
  final TextEditingController formControllerPhone = TextEditingController();
  final TextEditingController formControllerCode = TextEditingController();

  Rx<UserApp> user = Rx<UserApp>(UserEmpty());
  Rx<String> avatarURL = Rx<String>('');
  Rx<AppForm> appFormWidget = Rx<AppForm>(RegisterPhoneForm());
  Rx<ProfileViewWidget> profileWidget = Rx<ProfileViewWidget>(LoginWidget());



  final formType = FormType.login.obs;

  // void switchForm(){
  //   formType.value =
  //   formType.value == FormType.login ? FormType.register : FormType.login;
  //   //update();
  // }

  // Future<void> signUp({required String email, required String pass, required String phone}) async{
  //   try{
  //     //TODO для Андроид добавить нативное получение своего номера
  //     String phoneN = _correctPhoneNum(phone);
  //     await _firebaseRepository.signUp(email: email, password: pass, phone: phoneN);
  //     _confirmUser();
  //     _getUserContact();
  //   } on Exception {
  //     user.value = UserEmpty();
  //   }
  //   //update();
  // }
  //
  // Future<void> signIn({required String email, required String pass}) async{
  //   try {
  //     await _firebaseRepository.signIn(email: email, password: pass);
  //     _confirmUser();
  //     _getUserContact();
  //   } on Exception{
  //     user.value = UserEmpty();
  //     appFormWidget(LoginPhoneForm());
  //   }
  //   //update();
  // }

  Future<void> signUpWithSMSCode()async{
    try {
      await _firebaseRepository.signUpWithSMSCode(smsCode: formControllerCode.text.trim());
      _confirmUser();
      _getUserContact();
      //update();
    }on Exception{
      user.value = UserEmpty();
      appFormWidget(LoginPhoneForm());
    }

  }

  Future<void> verifyPhone()async{
    try {
        if(!formKey.currentState!.validate()) {
          formKey.currentState!.save();
        }else {
         String phoneN = _correctPhoneNum(formControllerPhone.text.trim());
         await _firebaseRepository.verifyPhoneNumber(phoneNumber: phoneN, email: formControllerEmail.text.trim());
        //await _firebaseRepository.verifyPhoneNumber(phoneNumber: '79258036135',email: 'merida-di@yandex.ru');
        //_confirmUser();
        appFormWidget(LoginPhoneForm());
      }

    } on Exception{
      user.value = UserEmpty();
      appFormWidget(RegisterPhoneForm());
    }
    //update();
  }

  void autoVerification(){
    _confirmUser();
    //update();
  }

  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    Get.delete<WishListController>();
    Get.lazyPut<WishListController>(() => WishListController(FirebaseWishRepository()));
    user.value = UserEmpty();
    profileWidget(LoginWidget());
    _getUserContact();
    //update();
  }

  void _confirmUser(){
    user.value = UserFirebase.fromFirebaseUser(_firebaseRepository.getCurrentUser());
    avatarURL.value = user.value.photoURL;
    if(user.value.userStatus == UserStatus.authenticated) {
      profileWidget(ProfileWidget());
    }
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

  // void _setPrefTheme(){
  //   if (Get.theme. == 'blackcrows'){
  //     Get.changeTheme(themeBlackCrows);
  //     Get.find<HomeController>().isThemeLightShampoo.value = false;
  //     Get.find<HomeController>().isThemeBlackCrows.value = true;
  //   }else{
  //     Get.changeTheme(themeLightShampoo);
  //     Get.find<HomeController>().isThemeLightShampoo.value = true;
  //     Get.find<HomeController>().isThemeBlackCrows.value = false;
  //   }
  // }

  String _correctPhoneNum(String phoneNum){
    String phoneN = phoneNum;
    if(phoneNum.length == 11) {
      if(phoneNum.startsWith('8')) {
        phoneN = phoneNum.replaceFirst('8', '7');
      }
    }else if(phoneNum.length == 10){
      phoneN = '7$phoneNum';
    }
    return phoneN;
  }


  _getPreferencesInstance() async {
    preferences = await SharedPreferences.getInstance();
  }

  void _setPrefLocale(String languageCode){
    if(languageCode == 'en'){
      Get.updateLocale(const Locale('en', 'UK'));
    }else{
      Get.updateLocale(const Locale('ru', 'RU'));
    }
  }

  void _initPreferences(){
    _setPrefLocale(preferences.getString('locale') ?? Get.deviceLocale!.languageCode);
    //_setPrefTheme(preferences.getString('theme') ?? 'lightshampoo');

  }


  // void _deleteImageFromCache(String imgURL){
  //   try {
  //     CachedNetworkImage.evictFromCache(imgURL);
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }
  

  @override
  void onInit() async{
    _confirmUser();
    await _getPreferencesInstance();
    _initPreferences();
    super.onInit();
  }

}