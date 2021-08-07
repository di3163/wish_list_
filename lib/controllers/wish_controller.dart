import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class WishController extends GetxController{
  WishController(this._firebaseRepository, this._picker);

  //final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
  final WishRepositoryInterface _firebaseRepository;
  final controllerTitle = TextEditingController().obs;
  final controllerDescription = TextEditingController().obs;
  final controllerLink = TextEditingController().obs;

  //final _picker = ImagePicker();
  final _picker;
  List<String> listImg = [];
  Wish currentWish = Wish.empty();
  bool isChanged = false;

  void addImage()async{
    final XFile?  pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 1,
    );
    if (pickedFile != null){
      if (!currentWish.isSaved){
        listImg.add(pickedFile.path);
      }else{
        listImg.add(await _uploadImage(pickedFile.path));
        await _firebaseRepository.updateUserWish(currentWish);
      }
    }
    update(['images']);
  }

  //TODO при выходе если были изменения спрашивать сохранить или нет

  Future<String> _uploadImage(String path)async{
    return  await _firebaseRepository.saveImage(File(path));
  }

  _addWishListPicURL()async{
      for(String element in listImg){
        String uRL = await _uploadImage(element);
        currentWish.listPicURL.add(uRL);
      }
  }

  void saveWish()async{
    if(controllerTitle.value.text.isEmpty){
      //TODO ссобщать что поле пустое, сохранение невозможно
      return;
    }
    await _addWishListPicURL();
    currentWish.title = controllerTitle.value.text;
    currentWish.description = controllerDescription.value.text;
    currentWish.link = controllerLink.value.text;
    _firebaseRepository.addUserWish(currentWish);
  }

  Future<void> updateWish()async {
    currentWish.title = controllerTitle.value.text;
    currentWish.description = controllerDescription.value.text;
    currentWish.link = controllerLink.value.text;
    await _firebaseRepository.updateUserWish(currentWish);
  }

  void deleteImage(String imgUrl)async{
      if(currentWish.isSaved) {
        try{
          await _firebaseRepository.deleteImage(imgUrl);
          currentWish.listPicURL.remove(imgUrl);
          await _firebaseRepository.updateUserWish(currentWish);
        }catch(e){

        }
      }else{
        listImg.remove(imgUrl);
      }
      update(['images']);
  }


  @override
  void onInit() {
    currentWish = Get.arguments;
    listImg = currentWish.listPicURL;
    controllerTitle.value.text = currentWish.title;
    controllerDescription.value.text = currentWish.description!;
    controllerLink.value.text = currentWish.link!;
    super.onInit();
  }

  // @override
  void onClose() async {
    if (isChanged)
    Get.defaultDialog(
        title: 'сохранить изменения?',
        onConfirm: () async {
          await updateWish();
          Get.back();
        },
        onCancel: () {},
        middleText: '',
    );
    super.onClose();
  }



// @override
  // void dispose() {
  //   controllerTitle.close();
  //   controllerDescription.close();
  //   controllerLink.close();
  //   super.dispose();
  // }
}