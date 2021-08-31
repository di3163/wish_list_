import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';

class ContactXView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<ContactsXController>(
          builder: (ContactsXController contactsController) {
        return contactsController.contactWidget.value.render();
      }),
    );
  }
}
