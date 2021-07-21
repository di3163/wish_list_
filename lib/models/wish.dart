import 'package:get/get.dart';

class Wish extends GetxController{
  String title;
  String? description;
  String? link;
  //List<String>? filesList;

  //final List<String> listPicURL.obs;
  //List<UserContact> userContactList = <UserContact>[].obs;
  List<String> listPicURL;

  Wish({required this.title, this.description, this.link,
    required this.listPicURL});

  Wish.empty() : this.title = '',
        this.description = '',
        this.link = '',
        this.listPicURL = [];
}