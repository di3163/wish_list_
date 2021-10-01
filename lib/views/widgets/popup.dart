
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class AppDialog {

  final String? titleText;
  final String? middleText;
  final VoidCallback? confirm;
  final VoidCallback? cancel;

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
        confirm ?? {};
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

  showSnackBar(String title, String message){
    Get.snackbar(
      title,
      message,
      colorText: Get.theme.hintColor,
      isDismissible: true,
      duration: const Duration(seconds: 5),
    );
  }
}
