import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_gx/core.dart';

class UserProfileController extends GetxController {

  UserProfileController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  late SharedPreferences preferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController formControllerEmail = TextEditingController();
  final TextEditingController formControllerPhone = TextEditingController();
  final TextEditingController formControllerCode = TextEditingController();


  Rx<UserApp> user = Rx<UserApp>(UserEmpty.empty());
  Rx<String> avatarURL = Rx<String>('');
  Rx<AppForm> appFormWidget = Rx<AppForm>(RegisterPhoneForm());
  Rx<ProfileViewWidget> profileWidget = Rx<ProfileViewWidget>(
      const LoginWidget());
  Rx<dynamic> autchData = Rx<dynamic>('');

  void bindUid(){
    autchData.bindStream(_firebaseRepository.fetchAutchDataStream());
  }

  Future<void> signUpWithSMSCode() async {
    if (!await CheckConnect.check()){
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    try {
      await _firebaseRepository.signUpWithSMSCode(
          smsCode: formControllerCode.text.trim());
      _confirmUser();
      //Get.find<ContactsXController>().getContacts();
      Get.find<ContactsXController>().updateContactWidget();
    } catch (e, s) {
      user.value = UserEmpty.empty();
      appFormWidget(LoginPhoneForm());
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
         await _firebaseRepository.verifyPhoneNumber(
            phoneNumber: phoneN,
            email: formControllerEmail.text.trim());
         //    ).then((_) => _autoVerification()
         //    ).catchError((e, s)async{
         //      user.value = UserEmpty.empty();
         //      appFormWidget(RegisterPhoneForm());
         //      await FirebaseCrash.error(e, s, 'err_auth'.tr, false);
         //      SnackbarGet.showSnackBar('err_auth'.tr);
         //    }
         // );
         // await Future.delayed(const Duration(seconds: 6));
         // _confirmUser();
         //
         if (user.value.userStatus == UserStatus.unauthenticated ){
            appFormWidget(LoginPhoneForm());
         }
       } catch (e, s) {
        user.value = UserEmpty.empty();
        appFormWidget(RegisterPhoneForm());
        await FirebaseCrash.error(e, s, 'err_auth'.tr, false);
        SnackbarGet.showSnackBar('err_auth'.tr);
      }
    }
  }

  void verificationFiled(Exception? err, StackTrace? s) async{
    user.value = UserEmpty.empty();
    appFormWidget(RegisterPhoneForm());
    await FirebaseCrash.error(err, s, 'err_auth'.tr, false);
    SnackbarGet.showSnackBar('err_auth'.tr);
  }

  // void verificationStrimHandling(){
  //   if(uid.value is Exception){
  //     _verificationFiled(uid.value, uid.value.stackTrace);
  //   } else{
  //     _autoVerification();
  //   }
  // }

  void autoVerification() {
    if(_firebaseRepository.fetchCurrentUser() != null) {
      _confirmUser();
      Get.find<ContactsXController>().updateContactWidget();
    }else{
      appFormWidget(LoginPhoneForm());
    }

  }


  Future<void> signOut() async {
    await _firebaseRepository.signOut();
    Get.delete<WishListController>();
    Get.lazyPut<WishListController>(() =>
        WishListController(FirebaseDataRepository()));
    user.value = UserEmpty.empty();
    profileWidget(const LoginWidget());
    Get.find<ContactsXController>().updateContactWidget();
    bindUid();
  }

  void _confirmUser() {
    user.value =
        UserFirebase.fromFirebaseUser(_firebaseRepository.fetchCurrentUser());
    avatarURL.value = user.value.photoURL;
    if (user.value.userStatus == UserStatus.authenticated) {
      profileWidget(const ProfileWidget());
      Get.find<HomeController>().user = user.value;
      //autchData.close();
    }else{
      bindUid();
    }
  }

  Future<XFile?> _pickedFile() async {
    try {
      return await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    } catch (e, s) {
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
    }
  }

  void addAvatar() async {
    final pickedFile = await _pickedFile();
    if (pickedFile == null) {
      SnackbarGet.showSnackBar('err_img_load'.tr);
      return;
    }
    if (!await CheckConnect.check()) {
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    try {
      if (user.value.photoURL.isNotEmpty) {
        await _firebaseRepository.deleteImage(user.value.photoURL);
      }
      String photoURL = await _firebaseRepository.saveImage(
          File(pickedFile.path));
      await _firebaseRepository.updateUserProfile(photoURL);
      avatarURL.value = photoURL;
    } catch (e, s) {
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
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


  _fetchPreferencesInstance() async {
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
    await _fetchPreferencesInstance();
    _initPreferences();

    super.onInit();
  }

  @override
  void onClose() {
    autchData.close();
    super.onClose();
  }



}