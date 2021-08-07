import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class ContactXView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<ContactsXController>(
          init: Get.put<ContactsXController>(ContactsXController(FirebaseAuthRepository())),
          builder: (ContactsXController contactsController) {
            if (contactsController.contacts.isNotEmpty) {
              return ListView.builder(
                itemCount: contactsController.contacts.length,
                itemBuilder: (_, val) => ListTile(
                  onTap: () {
                    Get.find<HomeController>().otherUserWishList(contactsController.contacts[val]);
                    //Get.back();
                    //Get.find<HomeController>().tabIndex = 2;
                    //Get.find<HomeController>().changeTabIndex(2, contactsController.contacts[val]);
                    //Get.find<HomeController>().pageController.jumpToPage(2);
                    //Get.find<WishListController>().bindListWish(contactsController.contacts[index]);
                    //return WishList()
                  },
                  title: Text(contactsController.contacts[val].name),
                  subtitle: Text(contactsController.contacts[val].phone),
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
