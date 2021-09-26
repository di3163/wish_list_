import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class WishController extends GetxController{
  WishController(this._firebaseRepository, this._picker);

  final WishRepositoryInterface _firebaseRepository;
  final controllerTitle = TextEditingController().obs;
  final controllerDescription = TextEditingController().obs;
  final controllerLink = TextEditingController().obs;

  final ImagePicker _picker;
  late List<String> listImgT;
  //List<String> listImg = [];
  Wish currentWish = Wish.empty();
  bool isChanged = false;

  Future<XFile?> _pickedFile() async{
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    }catch(e){
      _showSnackBar('err_img_load'.tr);
    }
  }

  void addImage() async {
    final pickedFile = await _pickedFile();
    if (pickedFile == null) {
      _showSnackBar('err_img_load'.tr);
      return;
    }
    if (!currentWish.isSaved) {
      listImgT.add(pickedFile.path);
      update(['images']);
    } else {
      if (!await CheckConnect().check()){
        _showSnackBar('err_network'.tr);
      }
      try {
        // String firebasePatch = await _uploadImage(pickedFile.path);
        String firebasePatch = await _firebaseRepository.saveImage(File(pickedFile.path));
        listImgT.add(firebasePatch);
        update(['images']);
        currentWish.listPicURL.add(firebasePatch);
        await _firebaseRepository.updateUserWish(currentWish);
      } catch (e) {
        _showSnackBar('err_img_load'.tr);
      }
    }
  }

  void deleteImage(String imgUrl)async{
    if(currentWish.isSaved) {
      if (!await CheckConnect().check()){
        _showSnackBar('err_network'.tr);
      }
      try {
        await _firebaseRepository.deleteImage(imgUrl);
        listImgT.remove(imgUrl);
        update(['images']);
        currentWish.listPicURL.remove(imgUrl);
        await _firebaseRepository.updateUserWish(currentWish);
      } catch(e){
        _showSnackBar(e.toString());
      }
    }else{
      listImgT.remove(imgUrl);
      update(['images']);
    }
  }

  // Future<String> _uploadImage(String path)async{
  //   return  await _firebaseRepository.saveImage(File(path));
  // }

  _addWishListPicURL()async{
      for(String element in listImgT){
        // String url = await _uploadImage(element);
        String url = await _firebaseRepository.saveImage(File(element));
        currentWish.listPicURL.add(url);
      }
  }

  void saveWish()async{
    if(controllerTitle.value.text.isEmpty){
      _showSnackBar('warn_title'.tr);
      return;
    }
    if (!await CheckConnect().check()){
      _showSnackBar('err_network'.tr);
    }
    try {
      await _addWishListPicURL();
      currentWish.title = controllerTitle.value.text;
      currentWish.description = controllerDescription.value.text;
      currentWish.link = controllerLink.value.text;
      _firebaseRepository.addUserWish(currentWish);
    }catch(e){
      _showSnackBar('err_sav'.tr);
    }
  }

  Future<void> updateWish()async {
    if(controllerTitle.value.text.isEmpty){
      _showSnackBar('warn_title'.tr);
      return;
    }
    if (!await CheckConnect().check()){
      _showSnackBar('err_network'.tr);
    }
    currentWish.title = controllerTitle.value.text;
    currentWish.description = controllerDescription.value.text;
    currentWish.link = controllerLink.value.text;
    try {
      await _firebaseRepository.updateUserWish(currentWish);
    }catch(e){
      _showSnackBar('err_sav'.tr);
    }
  }

  void _showSnackBar(String message){
    Get.snackbar(
      'err'.tr,
      message,
      isDismissible: true,
      duration: const Duration(seconds: 5),
    );
  }


  @override
  void onInit() {
    currentWish = Get.arguments;
    listImgT = currentWish.listPicURL.map((v) => v).toList();
    controllerTitle.value.text = currentWish.title;
    controllerDescription.value.text = currentWish.description!;
    controllerLink.value.text = currentWish.link!;
    super.onInit();
  }

  @override
  void onClose() async {
    if (isChanged) {
      Get.defaultDialog(
        title: 'save'.tr,
        backgroundColor: Get.theme.backgroundColor,
        buttonColor: Get.theme.buttonColor,
        onConfirm: () async {
          await updateWish();
          Get.back();
        },
        onCancel: () => Get.back(),
        middleText: '',
      );
    }
    super.onClose();
  }

}