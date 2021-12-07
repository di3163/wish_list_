
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

typedef ConfirmOperation<Wish> = Function(Wish wish);

class AppDialog {

  final String? titleText;
  final String? middleText;
  final ConfirmOperation<Wish>? confirm;
  final VoidCallback? cancel;
  //Confirm confirm;

  const AppDialog({
    this.titleText,
    this.middleText,
    this.confirm,
    this.cancel
  });

  getDialog(){
    return Get.defaultDialog(
      title: titleText ?? '',
      backgroundColor: Get.theme.backgroundColor,
      buttonColor: Get.theme.bottomAppBarColor,
      onConfirm: () {
        this.confirm ?? {};
        Get.back();
      },
      onCancel: () {
        cancel ?? {};
        Get.back();
      },
      middleText: middleText ?? '',
    );
  }
}

class SnackbarGet{

  static showSnackBar(String title, [String? message]){
    Get.snackbar(
      title,
      message ?? '',
      colorText: Get.theme.hintColor,
      isDismissible: true,
      duration: const Duration(seconds: 5),
    );
  }
}
