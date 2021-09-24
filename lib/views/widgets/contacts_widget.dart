import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class ContactWidget {
  Widget render();
}

class ErrorContactWidget extends ContactWidget{
  String state;

  ErrorContactWidget(this.state);

  @override
  Widget render() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconError, size: 30, color: Get.theme.accentColor,),
            const SizedBox(height: 10,),
            Text(state),
          ],
        )
    );
  }
}

class EmptyContactWidget extends ContactWidget{

  @override
  Widget render() {
    return Center(
      child:
        Text('empty_list' .tr)
    );
  }
}

class LoadedContactWidget extends ContactWidget{
  List<UserOther> contacts;

  LoadedContactWidget(this.contacts);

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
        trailing: contacts[val].photoURL.isEmpty ?
        Icon(iconPerson, color: Get.theme.accentColor) :

          CachedNetworkImage(
            imageUrl: contacts[val].photoURL,
            imageBuilder: (context, imageProvider) => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => Icon(iconPerson, color: Get.theme.accentColor),
            errorWidget: (context, url, error) => Icon(iconPerson, color: Get.theme.accentColor),
          ),
        ),

    );
  }
}

class LoadingContactWidget extends ContactWidget{

  @override
  Widget render() {
    return const Center(
        child: CircularProgressIndicator()
    );
  }
}