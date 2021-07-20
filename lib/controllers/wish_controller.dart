import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wish_list_gx/core.dart';

class WishController extends GetxController{
  final controllerTitle = TextEditingController().obs;
  final controllerDescription = TextEditingController().obs;
  final controllerLink = TextEditingController().obs;

  final _picker = ImagePicker();

  late Wish currentWish;

  void addImage()async{
    final XFile?  pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    currentWish.listPicURL.add(pickedFile.path);
  }

  @override
  void onInit() {
    currentWish = Get.arguments;
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