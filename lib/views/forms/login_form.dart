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
  final UserController _userController = Get.find<UserController>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onLogin() async {
    if (!_userController.formKey.value.currentState!.validate()) {
      //setState(() {
      _userController.formKey.value.currentState!.save();
      //});
    } else {
      _userController.formKey.value.currentState!.save();
      _userController.signIn(email: _controllerEmail.text.trim(), pass: _controllerPassword.text);
      _userController.formKey.value.currentState!.reset();
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _userController.formKey.value,
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
