import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class AppForm{
  Widget render();
}

class RegisterPhoneForm extends AppForm{

  
  @override
  Widget render() {
    return Form(
      key: Get.find<UserProfileController>().formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: const Key('fieldEmail'),
            validator: (value){
              if(value == '') return 'input_email' .tr;
              if (!validateEmail(value!)) return 'wrong_email' .tr;
              return null;
            },
            controller: Get.find<UserProfileController>().formControllerEmail,
            decoration: _buildInputDecoration('email' .tr , const Icon(iconEmail, size: 30)),
          ),
          
          TextFormField(
            keyboardType: TextInputType.number,
            key: const Key('phoneNum'),
            validator: (value){
              if(value == '') return 'input_phone' .tr;
              if (!validatePhone(value!)) return 'wrong_phone' .tr;
              return null;
            },
            controller: Get.find<UserProfileController>().formControllerPhone,
            decoration: _buildInputDecoration('phone' .tr , Icon(iconPhone, size: 30)),
          ),
          const SizedBox(height: 20),
          const _FormButtonWidget(formButton: RegisterPhoneButton()),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, Icon icon) {
    return InputDecoration(
      labelText: label,
      icon: icon,
    );
  }
  
}

class LoginPhoneForm extends AppForm{

  @override
  Widget render() {
    return Form(
      key: Get.find<UserProfileController>().formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            key: const Key('fieldCode'),
            controller: Get.find<UserProfileController>().formControllerCode,
            decoration: _buildInputDecoration('code' .tr, const Icon(iconCode, size: 30,)),
          ),
          const SizedBox(height: 20),
          const _FormButtonWidget(formButton: CodeSendButton()),
        ],
      ),
    );
  }
  InputDecoration _buildInputDecoration(String label, Icon icon) {
    return InputDecoration(
      labelText: label,
      icon: icon,
    );
    }
  }


class _FormButtonWidget extends StatelessWidget {
  final FormButton formButton;

  const _FormButtonWidget({Key? key, this.formButton = const EmptyFormButton()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: formButton.onButtonClicked,
      child: Text(formButton.text),
    );
  }
}
