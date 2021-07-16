import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class ContactXView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<ContactsXController>(
          init: Get.put<ContactsXController>(ContactsXController()),
          builder: (ContactsXController contactsController) {
            if (contactsController.contacts.isNotEmpty) {
              return ListView.builder(
                itemCount: contactsController.contacts.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(contactsController.contacts[index].name),
                  subtitle: Text(contactsController.contacts[index].phone),
                ),
              );
            } else if (contactsController.errorStatus.isNotEmpty) {
              return Center(
                child: Text(contactsController.errorStatus.value),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
