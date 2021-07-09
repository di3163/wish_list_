import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Column _profile(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 30),
      Text('user'),
      SizedBox(height: 30),
      ElevatedButton(
        onPressed: () {},//_signOut,
        child: Text('sign_out' .tr),
      ),
    ],
  );
}