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
    if (pickedFile != null)
    //currentWish.listPicURL.add(pickedFile.path);
      listImg.add(pickedFile.path);
    update();
  }

  _uploadImages()async{
      for(String element in listImg){
        String uRL = await _firebaseRepository.saveImage(File(element));
        currentWish.listPicURL.add(uRL);
      }
  }

  void saveWish()async{
    if(controllerTitle.value.text.isEmpty){
      return;
    }
    await _uploadImages();
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