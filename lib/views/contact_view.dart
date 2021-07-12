import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wish_list_gx/core.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsController>(
        builder: (controller)  {
          if(controller.status.isDenied){
            controller.requestContactsPermit();
          }
          return contactList();
        }
    );
  }

  Container contactList(){
    return Container(
      child: Center(
        child:
        Text('conta'),
      ),
    );
  }
}


