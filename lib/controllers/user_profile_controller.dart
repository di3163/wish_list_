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
  Rx<ProfileViewWidget> profileWidget = Rx<ProfileViewWidget>(const LoginWidget());

  Future<void> signUpWithSMSCode()async{
    try {
      await _firebaseRepository.signUpWithSMSCode(smsCode: formControllerCode.text.trim());
      _confirmUser();
      Get.find<ContactsXController>().getContacts();
    }catch(e){
      user.value = UserEmpty();
      appFormWidget(LoginPhoneForm());
      SnackbarGet().showSnackBar('err'.tr, e.toString());
    }
  }

  Future<void> verifyPhone() async {
      if (!formKey.currentState!.validate()) {
        formKey.currentState!.save();
      } else {
        String phoneN = _correctPhoneNum(formControllerPhone.text.trim());
        try {
          await _firebaseRepository.verifyPhoneNumber(
            phoneNumber: phoneN,
            email: formControllerEmail.text.trim()
          );
        } catch(e){
          user.value = UserEmpty();
          appFormWidget(RegisterPhoneForm());
          SnackbarGet().showSnackBar('err'.tr, e.toString());
        }
        appFormWidget(LoginPhoneForm());
      }
  }

  void verificationFiled(String codeErr){
    user.value = UserEmpty();
    appFormWidget(RegisterPhoneForm());
    SnackbarGet().showSnackBar('err'.tr, codeErr);
  }

  void autoVerification(){
    _confirmUser();
    Get.find<ContactsXController>().getContacts();
  }


  Future<void> signOut() async{
    await _firebaseRepository.signOut();
    Get.delete<WishListController>();
    Get.lazyPut<WishListController>(() => WishListController(FirebaseWishRepository()));
    user.value = UserEmpty();
    profileWidget(const LoginWidget());
    Get.find<ContactsXController>().getContacts();
  }

  void _confirmUser(){
    user.value = UserFirebase.fromFirebaseUser(_firebaseRepository.getCurrentUser());
    avatarURL.value = user.value.photoURL;
    if(user.value.userStatus == UserStatus.authenticated) {
      profileWidget(const ProfileWidget());
    }
  }

  void addAvatar()async{
    final XFile?  pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedFile != null){
      try {
        if (user.value.photoURL.isNotEmpty) {
          await _firebaseRepository.deleteImage(user.value.photoURL);
        }
        String photoURL = await _firebaseRepository.saveImage(
            File(pickedFile.path));
        await _firebaseRepository.updateUserProfile(photoURL);
        avatarURL.value = photoURL;
      }catch(e){
        SnackbarGet().showSnackBar('err'.tr, e.toString());
      }
    }
  }


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
    var deviceLocale = Get.deviceLocale;
    _setPrefLocale(preferences.getString('locale') ?? deviceLocale!.languageCode);
  }


  @override
  void onInit() async{
    _confirmUser();
    await _getPreferencesInstance();
    _initPreferences();
    super.onInit();
  }

}