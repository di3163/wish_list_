import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';


class LoginForm extends StatelessWidget {
  LoginForm({Key? key, required this.userProfileController}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserProfileController userProfileController;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      _formKey.currentState!.save();
      userProfileController.signIn(email: _controllerEmail.text.trim(), pass: _controllerPassword.text);
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
            decoration: _buildInputDecoration('email' .tr, Icon(iconEmail, size: 30)),
          ),
          TextFormField(
            key: Key('fieldPass'),
            validator: (value) {
              if (value == '') return 'input_password' .tr;
              return null;
            },
            controller: _controllerPassword,
            decoration: _buildInputDecoration('password' .tr, Icon(iconKey, size: 30)),
          ),
          SizedBox(height: 20),
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
