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

class ButtonWidget extends StatelessWidget {
  final FormButton formButton;

  const ButtonWidget({Key? key, this.formButton = const EmptyFormButton()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: formButton.onButtonClicked,
      child: Text(formButton.text),
    );
  }
}
