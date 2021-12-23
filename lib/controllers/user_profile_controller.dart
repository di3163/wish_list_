import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController {


  late final AuthRepositoryInterface _authRepository;
  late SharedPreferences preferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController formControllerEmail = TextEditingController();
  final TextEditingController formControllerPhone = TextEditingController();
  final TextEditingController formControllerCode = TextEditingController();


  Rx<UserApp> user = Rx<UserApp>(UserEmpty.empty());
  Rx<String> avatarURL = Rx<String>('');
  Rx<AppForm> appFormWidget = Rx<AppForm>(const RegisterPhoneForm());
  Rx<ProfileViewWidget> profileWidget = Rx<ProfileViewWidget>(
      const LoginWidget());
  Rx<dynamic> autchData = Rx<dynamic>('');

  void _bindUid(){
    //autchData.bindStream(_authRepository.fetchAutchDataStream());
    autchData.bindStream(_authRepository.autchDataStream);
  }

  void signUpWithSMSCode() async {
    if (!await CheckConnect.check()){
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    try {
      await _authRepository.signUpWithSMSCode(
          smsCode: formControllerCode.text.trim());
      _confirmUser();
      //Get.find<ContactsXController>().getContacts();
      Get.find<ContactsXController>().updateContactWidget();
      _authRepository.autchComplete();
    } catch (e, s) {
      user.value = UserEmpty.empty();
      appFormWidget(const LoginPhoneForm());
      await FirebaseCrash.error(e, s, 'err_auth'.tr, false);
      SnackbarGet.showSnackBar('err_auth'.tr);
    }
  }

  void verifyPhone() async {
    if (!await CheckConnect.check()){
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    if (!formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      String phoneN = _correctPhoneNum(formControllerPhone.text.trim());
      try {
         await _authRepository.verifyPhoneNumber(
            phoneNumber: phoneN,
            email: formControllerEmail.text.trim()
         );
         if (user.value.userStatus == UserStatus.unauthenticated ){
            appFormWidget(const LoginPhoneForm());
         }
       } catch (e, s) {
        user.value = UserEmpty.empty();
        appFormWidget(const RegisterPhoneForm());
        await FirebaseCrash.error(e, s, 'err_auth'.tr, false);
        SnackbarGet.showSnackBar('err_auth'.tr);
      }
    }
  }

  void verificationFiled(Exception? err, StackTrace? s) async{
    user.value = UserEmpty.empty();
    appFormWidget(const RegisterPhoneForm());
    await FirebaseCrash.error(err, s, 'err_auth'.tr, false);
    SnackbarGet.showSnackBar('err_auth'.tr);
  }


  void autoVerification() {
    _confirmUser();
    if(user.value.userStatus == UserStatus.authenticated){
      Get.find<ContactsXController>().updateContactWidget();
      _authRepository.autchComplete();
    }else{
      appFormWidget(const LoginPhoneForm());
    }
  }


  void signOut() async {
    await _authRepository.signOut();
    //Get.find<WishListController>().clearListWish();
    Get.delete<WishListController>();
    Get.lazyPut<WishListController>(() =>
        WishListController());
    user.value = UserEmpty.empty();
    profileWidget(const LoginWidget());
    Get.find<ContactsXController>().updateContactWidget();
    //_bindUid();
  }

  void _confirmUser() async{
    try{
    user.value =
        UserFirebase.fromFirebaseUser(_authRepository.fetchCurrentUser());
    avatarURL.value = user.value.photoURL;
    if (user.value.userStatus == UserStatus.authenticated) {
      profileWidget(const ProfileWidget());
      Get.find<HomeController>().user = user.value;
      //autchData.close();
    }
      //_bindUid();
    }on NullFromFirebaseException catch(e) {
      user.value = UserEmpty.empty();
    }catch (e, s){
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
    }
  }

  Future<XFile?> _pickedFile() async {
    try {
      return await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    } catch (e) {
      //await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
    }
  }

  void addAvatar() async {
    final pickedFile = await _pickedFile();
    if (pickedFile == null) {
      SnackbarGet.showSnackBar('err_img_load'.tr);
    } else{
      if (!await CheckConnect.check()) {
        SnackbarGet.showSnackBar('err_network'.tr);
      }else {
        if (user.value.photoURL.isNotEmpty) {
          await _deleteAvatar(user.value.photoURL);
        }
        _saveAvatar(pickedFile);
      }
    }

  }

  void _saveAvatar(XFile pickedFile) async{
    try {
      String photoURL = await _authRepository.saveImage(
          File(pickedFile.path));
      await _authRepository.updateUserProfile(photoURL);
      avatarURL.value = photoURL;
    } catch (e, s) {
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
    }
  }

  Future<void> _deleteAvatar(String url)async{
    try{
      await _authRepository.deleteImage(url);
    }on DeleteFileException catch(e,s){
      await FirebaseCrash.error(e, s, 'err_file_delete'.tr, false);
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


  Future<void> _fetchPreferencesInstance() async {
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
    _authRepository = Get.find<AuthRepositoryInterface>();
    _confirmUser();
    await _fetchPreferencesInstance();
    _initPreferences();
    _bindUid();
    super.onInit();
  }

  @override
  void onClose() {
    autchData.close();
    super.onClose();
  }



}