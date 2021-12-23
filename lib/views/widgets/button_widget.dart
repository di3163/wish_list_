import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  const RegisterPhoneButton({required this.onClic});
  final Function onClic;

  @override
  String get text => 'log_in'.tr;

  @override
  void onButtonClicked() => onClic();

}

class CodeSendButton extends FormButton{

  const CodeSendButton({required this.onClic});
  final Function onClic;

  @override
  String get text => 'send_code'.tr;

  @override
  void onButtonClicked() => onClic();
}

class OkButton extends FormButton{

  const OkButton({required this.onClic});
  final Function onClic;

  @override
  String get text => 'ok'.tr;

  @override
  void onButtonClicked() => onClic();
}

class CancelButton extends FormButton{

  const CancelButton({required this.onClic});
  final Function onClic;

  @override
  String get text => 'cancel'.tr;

  @override
  void onButtonClicked() => onClic();
}

abstract class ButtonWidget extends StatelessWidget{
  const ButtonWidget({Key? key, required this.formButton}) : super(key: key);
  final FormButton formButton;
}

class ElevatedButtonWidget extends ButtonWidget {
  const ElevatedButtonWidget({Key? key, required FormButton formButton})
      : super(key: key, formButton: formButton);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: formButton.onButtonClicked,
      child: Text(formButton.text),
    );
  }
}

class IconButtonWidget extends ButtonWidget{
  const IconButtonWidget({Key? key, required FormButton formButton, required this.icon})
      : super(key: key, formButton: formButton);

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: formButton.onButtonClicked,
        icon: icon,
      iconSize: 60,
      color:  Get.theme.focusColor,
    );
  }
}
