import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

abstract class ContactWidget extends StatelessWidget{
  const ContactWidget({Key? key}) : super(key: key);
  //Widget render();
}

class ErrorContactWidget extends ContactWidget{
  final String state;

  const ErrorContactWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  const EmptyContactWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        Text('empty_list' .tr)
    );
  }
}

class LoadedContactWidget extends ContactWidget{
  final List<UserOther> contacts;

  const LoadedContactWidget({Key? key, required this.contacts}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey(key),
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
          cacheManager: Get.find<CacheManager>(),
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

  const LoadingContactWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(),
    );
  }
}