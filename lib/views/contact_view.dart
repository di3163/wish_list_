import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wish_list_gx/core.dart';

class ContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsController>(
        builder: (controller)  {
          if(controller.status.isGranted){
            if(controller.errorStatus.isNotEmpty){
              return Center(
                child: Text(controller.errorStatus),
              );
            }
            //обработку ошибок сделать
            if(controller.userContactList.isEmpty){
              //здесь выводить инфу что список пуст
              return Center(child: Text('empty'));
            }else{
              return contactList(controller);
            }
          }else {
            controller.requestContactsPermit();
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  Container contactList(ContactsController controller){
    return Container(
      child: ListView.builder(
        itemCount: controller.userContactList.length,
          itemBuilder: (context, index) =>  ListTile(
              title: Text(controller.userContactList[index].name),
              subtitle: Text(controller.userContactList[index].phone),
            ),
          ),
    );
  }
}


