import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Wish {
  String id = '';
  String title;
  String? description;
  String? link;
  bool isSaved = false;

  List<String> listPicURL;

  Wish({required this.title, this.description, this.link,
    required this.listPicURL});

  Wish.empty() :
        id ='',
        title = '',
        description = '',
        link = '',
        listPicURL = [],
        isSaved = false;

  Wish.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) :
    id = documentSnapshot.id,
    title = documentSnapshot["title"],
    description = documentSnapshot["description"],
    link = documentSnapshot["link"],
    listPicURL = List<String>.from(documentSnapshot["listImg"]),
    isSaved = true;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'link': link,
    'listImg': listPicURL
  };

  // Future<List<String>> _listCachedUrl(List<String> dataUrl)async{
  //   List<String> _listUrl = [];
  //   for (String element in dataUrl){
  //     var fetchedFile = await DefaultCacheManager().getSingleFile(element);
  //     _listUrl.add(fetchedFile.path);
  //   }
  //   return _listUrl;
  // }
}