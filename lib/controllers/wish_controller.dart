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

  void addImage()async{
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
      if (pickedFile != null) {
        if (!currentWish.isSaved) {
          listImgT.add(pickedFile.path);
        } else {
          //listImgT.add(await _uploadImage(pickedFile.path));
          listImgT.add(pickedFile.path);
          currentWish.listPicURL.add(await _uploadImage(pickedFile.path));
          await _firebaseRepository.updateUserWish(currentWish);
        }
      }
    }catch(e){
      _showSnackBar('err_img_load'.tr);
    }
    update(['images']);
  }

  Future<String> _uploadImage(String path)async{
    return  await _firebaseRepository.saveImage(File(path));
  }

  _addWishListPicURL()async{
      for(String element in listImgT){
        String uRL = await _uploadImage(element);
        currentWish.listPicURL.add(uRL);
      }
  }

  void saveWish()async{
    if(controllerTitle.value.text.isEmpty){
      _showSnackBar('warn_title'.tr);
      return;
    }
    try {
      await _addWishListPicURL();
      currentWish.title = controllerTitle.value.text;
      currentWish.description = controllerDescription.value.text;
      currentWish.link = controllerLink.value.text;
      _firebaseRepository.addUserWish(currentWish);
    }catch(e){
      _showSnackBar(e.toString());
    }
  }

  Future<void> updateWish()async {
    currentWish.title = controllerTitle.value.text;
    currentWish.description = controllerDescription.value.text;
    currentWish.link = controllerLink.value.text;
    try {
      await _firebaseRepository.updateUserWish(currentWish);
    }catch(e){
      _showSnackBar(e.toString());
    }
  }

  void deleteImage(String imgUrl)async{
      if(currentWish.isSaved) {
        try {
          await _firebaseRepository.deleteImage(imgUrl);
          currentWish.listPicURL.remove(imgUrl);
          await _firebaseRepository.updateUserWish(currentWish);
        } catch(e){
          _showSnackBar(e.toString());
        }
      }else{
        listImgT.remove(imgUrl);
      }
      update(['images']);
  }

  void _showSnackBar(String message){
    Get.snackbar(
      'err'.tr,
      message,
      isDismissible: true,
      duration: const Duration(seconds: 10),
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
        title: 'сохранить изменения?',
        backgroundColor: Get.theme.backgroundColor,
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