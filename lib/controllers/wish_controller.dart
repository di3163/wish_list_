import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class WishController extends GetxController{

  late final DataRepositoryInterface _dataRepository;
  final controllerTitle = TextEditingController().obs;
  final controllerDescription = TextEditingController().obs;
  final controllerLink = TextEditingController().obs;

  //final ImagePicker _picker;
  late List<String> listImgT;
  Wish currentWish = Wish.empty();
  bool isChanged = false;

  Future<XFile?> _pickedFileGallery() async{
    try {
      return await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
    }
  }

  Future<XFile?> _pickedFileCamera() async{
    try {
      return await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
      SnackbarGet.showSnackBar('err_img_load'.tr);
    }
  }

  void addImageCamera() async {
    XFile? pickedFile;
    pickedFile = await _pickedFileCamera();
    if (pickedFile == null) {
      SnackbarGet.showSnackBar('err_img_load'.tr);
      return;
    }
    _saveImage(pickedFile);
  }

  void addImageGallery() async {
    XFile? pickedFile;
    pickedFile = await _pickedFileGallery();
    if (pickedFile == null) {
      SnackbarGet.showSnackBar('err_img_load'.tr);
      return;
    }
    _saveImage(pickedFile);
  }

  void _saveImage(XFile pickedFile) async{
    if (!currentWish.isSaved) {
      listImgT.add(pickedFile.path);
      update(['images']);
    } else {
      if (!await CheckConnect.check()){
        SnackbarGet.showSnackBar('err_network'.tr);
      }
      try {
        String firebasePatch = await _dataRepository.saveImage(File(pickedFile.path));
        listImgT.add(firebasePatch);
        update(['images']);
        currentWish.listPicURL.add(firebasePatch);
        await _dataRepository.updateUserWish(currentWish);
      } catch (e, s) {
        await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
        SnackbarGet.showSnackBar('err_img_load'.tr);
      }
    }
  }

  void deleteImage(String imgUrl)async{
    if(currentWish.isSaved) {
      if (!await CheckConnect.check()){
        SnackbarGet.showSnackBar('err_network'.tr);
      }
      try {
        await _dataRepository.deleteImage(imgUrl);
        listImgT.remove(imgUrl);
        update(['images']);
        currentWish.listPicURL.remove(imgUrl);
        await _dataRepository.updateUserWish(currentWish);
      } catch(e, s){
        await FirebaseCrash.error(e, s, 'err_img_load'.tr, false);
        SnackbarGet.showSnackBar('err'.tr);
      }
    }else{
      listImgT.remove(imgUrl);
      update(['images']);
    }
  }

  _addWishListPicURL()async{
      for(String element in listImgT){
        String url = await _dataRepository.saveImage(File(element));
        currentWish.listPicURL.add(url);
      }
  }

  void saveWish()async{
    if(controllerTitle.value.text.isEmpty){
      SnackbarGet.showSnackBar('warn_title'.tr);
      return;
    }
    if (!await CheckConnect.check()){
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    try {
      await _addWishListPicURL();
      currentWish.title = controllerTitle.value.text;
      currentWish.description = controllerDescription.value.text;
      currentWish.link = controllerLink.value.text;
      await _dataRepository.addUserWish(currentWish);
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_sav'.tr, false);
      SnackbarGet.showSnackBar('err_sav'.tr);
    }
    isChanged = false;
    Get.back();
  }

  Future<void> updateWish()async {
    if(controllerTitle.value.text.isEmpty){
      SnackbarGet.showSnackBar('warn_title'.tr);
      return;
    }
    if (!await CheckConnect.check()){
      SnackbarGet.showSnackBar('err_network'.tr);
    }
    currentWish.title = controllerTitle.value.text;
    currentWish.description = controllerDescription.value.text;
    currentWish.link = controllerLink.value.text;
    try {
      await _dataRepository.updateUserWish(currentWish);
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_sav'.tr, false);
      SnackbarGet.showSnackBar('err_sav'.tr);
    }
  }

  @override
  void onInit() {
    _dataRepository = Get.find<DataRepositoryInterface>();
    currentWish = Get.arguments;
    listImgT = currentWish.listPicURL.map((v) => v).toList();
    controllerTitle.value.text = currentWish.title;
    controllerDescription.value.text = currentWish.description!;
    controllerLink.value.text = currentWish.link!;
    super.onInit();
  }

  // @override
  // void onClose() {
  //   // if (isChanged) {
  //   //   // AppDialog(
  //   //   //   titleText: 'save'.tr,
  //   //   //   confirm: () async{
  //   //   //     await updateWish();
  //   //   //   },
  //   //   // ).getDialog();
  //   //   Get.defaultDialog(
  //   //     title: 'save'.tr,
  //   //     backgroundColor: Get.theme.backgroundColor,
  //   //     //buttonColor: Get.theme.bottomAppBarColor,
  //   //     onConfirm: () async {
  //   //       await updateWish();
  //   //       Get.back();
  //   //     },
  //   //     onCancel: () => Get.back(),
  //   //     middleText: '',
  //   //   );
  //   // }
  //   super.onClose();
  //}
}