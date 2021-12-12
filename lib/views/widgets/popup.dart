
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

typedef ConfirmOperation = void Function();

class AppDialog {

  final String? titleText;
  final String? middleText;
  final ConfirmOperation? confirm;
  final VoidCallback? cancel;
  //Confirm confirm;

  AppDialog({
    this.titleText,
    this.middleText,
    this.confirm,
    this.cancel
  });

  Future<void> getDialog() async{
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
