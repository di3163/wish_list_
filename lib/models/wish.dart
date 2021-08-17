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
        this.id ='',
        this.title = '',
        this.description = '',
        this.link = '',
        this.listPicURL = [],
        this.isSaved = false;

  Wish.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) :
    this.id = documentSnapshot.id,
    this.title = documentSnapshot["title"],
    this.description = documentSnapshot["description"],
    this.link = documentSnapshot["link"],
    //this.listPicURL = documentSnapshot["listImg"].cast<String>(),
    this.listPicURL = List<String>.from(documentSnapshot["listImg"]),
    isSaved = true;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'link': link,
    'listImg': listPicURL
  };
}