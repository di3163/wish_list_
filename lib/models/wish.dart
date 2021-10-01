import 'package:cloud_firestore/cloud_firestore.dart';

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
}