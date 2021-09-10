import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class FormButton{
  String get text;

  const FormButton();

  void onButtonClicked();
}

class EmptyFormButton extends FormButton{

  const EmptyFormButton();

  @override
  String get text => '';

  @override
  void onButtonClicked() {}
}

class RegisterPhoneButton extends FormButton{

  const RegisterPhoneButton();

  @override
  String get text => 'sign_up'.tr;

  @override
  void onButtonClicked() {
    Get.find<UserProfileController>().verifyPhone();
  }
}

class CodeSendButton extends FormButton{

  const CodeSendButton();

  @override
  String get text => 'send_code'.tr;

  @override
  void onButtonClicked() {
    Get.find<UserProfileController>().signUpWithSMSCode();
  }
}