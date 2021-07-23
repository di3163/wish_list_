import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class WishController extends GetxController{
  final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
  final controllerTitle = TextEditingController().obs;
  final controllerDescription = TextEditingController().obs;
  final controllerLink = TextEditingController().obs;

  final _picker = ImagePicker();
  List<String> listImg = [];

  late Wish currentWish;

  void addImage()async{
    final XFile?  pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      if (currentWish.title.isEmpty){
        listImg.add(pickedFile.path);
      }else{
        listImg.add(await _uploadImage(pickedFile.path));
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



  @override
  void onInit() {
    currentWish = Get.arguments;
    listImg = currentWish.listPicURL;
    controllerTitle.value.text = currentWish.title;
    super.onInit();
  }

  @override
  void dispose() {
    controllerTitle.close();
    controllerDescription.close();
    controllerLink.close();
    super.dispose();
  }
}