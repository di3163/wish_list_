import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';


// class LoginForm extends StatefulWidget {
//   LoginForm({Key? key}) : super(key: key);
//
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);
  final UserProfileController _userProfileController = Get.find<UserProfileController>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onLogin() async {
    if (!_userProfileController.formKey.value.currentState!.validate()) {
      //setState(() {
      _userProfileController.formKey.value.currentState!.save();
      //});
    } else {
      _userProfileController.formKey.value.currentState!.save();
      _userProfileController.signIn(email: _controllerEmail.text.trim(), pass: _controllerPassword.text);
      _userProfileController.formKey.value.currentState!.reset();
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userProfileController.formKey.value,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: Key('fieldEmail'),
            validator: (value) {
              if (value == '') return 'input_email' .tr;
              if (!validateEmail(value!)) return 'wrong_email' .tr;
              return null;
            },
            controller: _controllerEmail,
            decoration: _buildInputDecoration('email' .tr, Icon(Icons.alternate_email)),
          ),
          TextFormField(
            key: Key('fieldPass'),
            validator: (value) {
              if (value == '') return 'input_password' .tr;
              return null;
            },
            controller: _controllerPassword,
            decoration: _buildInputDecoration('password' .tr, Icon(Icons.vpn_key)),
          ),
          ElevatedButton(
            key: Key('buttonLoginSend'),
            onPressed: _onLogin,
            child: Text('log_in' .tr),
          ),
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
