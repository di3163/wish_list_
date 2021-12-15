import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class AppForm extends StatelessWidget{
  const AppForm({Key? key}) : super(key: key);
  //Widget render();
}

class RegisterPhoneForm extends AppForm{
  const RegisterPhoneForm({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
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
          ButtonWidget(formButton: RegisterPhoneButton(onClic: () => Get.find<UserProfileController>().verifyPhone())),
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
  const LoginPhoneForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ButtonWidget(formButton: CodeSendButton(onClic: () => Get.find<UserProfileController>().signUpWithSMSCode())),
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

