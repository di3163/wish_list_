import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class ContactState {
  Widget render();
}

class ErrorContactState extends ContactState{
  String state;

  ErrorContactState(this.state);

  @override
  Widget render() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconError, size: 30, color: Get.theme.accentColor,),
            SizedBox(height: 10,),
            Text(state),
          ],
        )
    );
  }
}

class EmptyContactState extends ContactState{

  @override
  Widget render() {
    return Center(
      child:
        Text('empty_list' .tr)
    );
  }
}

class LoadedContactState extends ContactState{
  List<UserOther> contacts;

  LoadedContactState(this.contacts);

  @override
  Widget render() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (_, val) => ListTile(
        onTap: () {
          Get.find<HomeController>().otherUserWishList(contacts[val]);
        },
        title: Text(contacts[val].name),
        subtitle: Text(contacts[val].phone),
      ),
    );
  }
}

class LoadingContactState extends ContactState{

  @override
  Widget render() {
    return Center(
        child: CircularProgressIndicator()
    );
  }
}