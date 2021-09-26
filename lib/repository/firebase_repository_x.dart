import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';


class WishOperationFailure implements Exception{}

abstract class WishRepositoryInterface {
  Future updateUserWish(Wish wish);
  Future addUserWish(Wish wish);
  Stream<List<Wish>> getUserWishStream(String id);
  deleteWish(Wish wish);
  Future<String> saveImage(File image);
  Future deleteImage(String imgUrl);
}


class FirebaseWishRepository extends WishRepositoryInterface{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference _getReference(String collection){
    return FirebaseFirestore.instance.collection(collection);
  }

  @override
  Future<void> addUserWish(Wish wish) async{
    try {
      CollectionReference ref = _getReference(_firebaseAuth.currentUser!.uid);
      await ref.add(
        wish.toJson()
      //     {
      //   'title': wish.title,
      //   'description': wish.description,
      //   'link': wish.link,
      //   'listImg': wish.listPicURL
      // }
      );
    }catch(e){
      print('repository addUserW ${e.toString()}');
      return Future.error('err_network'.tr);
      //throw WishOperationFailure();
    }
  }

  @override
  Future<void> deleteImage(String imgUrl) async{
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.refFromURL(imgUrl);
      await ref.delete();
    }catch(e){
      return Future.error('err_network'.tr);
    }
  }

  @override
  void deleteWish(Wish wish) async{
    //CollectionReference ref = _getReference(_firebaseAuth.currentUser!.uid);
    await _getReference(_firebaseAuth.currentUser!.uid).doc(wish.id).delete();
  }

  @override
  Stream<List<Wish>> getUserWishStream(String id) {
    try {
      return _getReference(id).snapshots().map((QuerySnapshot querySnapshot) {
        return [for(var element in querySnapshot.docs) Wish.fromDocumentSnapshot(element)];
        // List<Wish> listWish = [];
        // for(var element in querySnapshot.docs){
        //   listWish.add(Wish.fromDocumentSnapshot(element));
        // }
        // return listWish;
      }
      );
    }catch(e) {
      throw WishOperationFailure();
    }
  }

  @override
  Future<String> saveImage(File image) async{
    String imgURL = '';
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('users/${_firebaseAuth.currentUser!.uid}/${image.path.split('/').last}');
      UploadTask uploadTask = ref.putFile(image);
      await uploadTask.whenComplete(() async {
        imgURL = await uploadTask.snapshot.ref.getDownloadURL();
      });
     }catch(e){
       return Future.error('err_img_load'.tr);
     }

    return imgURL;
  }

  @override
  Future<void> updateUserWish(Wish wish) async{
    try {
      CollectionReference ref = _getReference(_firebaseAuth.currentUser!.uid);
      await ref.doc(wish.id).update(
        wish.toJson()
          // {
          //   'title': wish.title,
          //   'description': wish.description,
          //   'link': wish.link,
          //   'listImg': wish.listPicURL
          // }
      );
    }catch(e){
      return Future.error('err_network'.tr);
    }
  }

}