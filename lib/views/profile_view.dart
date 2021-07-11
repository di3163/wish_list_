import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

enum FormType { login, register }

class ProfileView extends StatelessWidget {
  FormType _formType = FormType.login;



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 43.0),
      child: GetBuilder<UserController>(
        builder: (controller) {
          return controller.userStatus.value == UserStatus.authenticated ?
          _profile() :  _login();
        }
      )
      // Get.find<UserController>().
      //   userStatus.value == UserStatus.authenticated ?
      //   _profile() :  _login(),

    );


  }




  Column _profile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Text('user'),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Get.find<UserController>().signOut(), //_signOut,
          child: Text('sign_out'.tr),
        ),
      ],
    );
  }

  Widget _login() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _formType == FormType.login ?
                  'log_in' .tr : 'sign_up' .tr,
              textAlign: TextAlign.start,
            ),
          ),
          LoginForm(),
          //_formType == FormType.login ? LoginForm() : RegisterForm(),


        ],
      ),
    );
  }
}