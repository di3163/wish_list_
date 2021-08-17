import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wish_list_gx/core.dart';

class AllUsersListFailure implements Exception {}
class LogInWithEmailAndPasswordFailure implements Exception {}
class SignUpFailure implements Exception {}
class WishOperationFailure implements Exception{}

abstract class AuthRepositoryInterface {

  Future<Map<dynamic, dynamic>> getAllRegistredUsers();

  Future signUp({required String email,
    required String password,
    required String phone});

  Future signIn({required String email,
    required String password});

  Future signOut();

  getCurrentUser();
}

abstract class WishRepositoryInterface {
  Future updateUserWish(Wish wish);
  Future addUserWish(Wish wish);
  Stream<List<Wish>> getUserWishStream(String id);
  deleteWish(Wish wish);
  Future<String> saveImage(File image);
  Future deleteImage(String imgUrl);
}


class FirebaseAuthRepository extends AuthRepositoryInterface{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  CollectionReference _getReference(String collection){
    return FirebaseFirestore.instance.collection(collection);
  }

  Future<void> _addUsersData(User user, String email, String phone)async {
    CollectionReference ref = _getReference('users');
    ref.doc(user.uid).set({
      'name': email,
      'email': user.email,
      'phone' :  phone,
    });
  }

  Future<void> _addUserToAllRegistred(User user, String phone) async {
    //TODO возвращать из этого метода allRegisterMap для дальнейшего использования
    //после создания пользователя

    //try {
    DocumentReference documentReference = _getReference('users').doc('register_users');
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      var data = snapshot.data() as Map;
      Map<String, dynamic> allregisterMap = data['all_register'] as Map<String, dynamic>;
      allregisterMap[phone] = user.uid;
      transaction.update(documentReference, {'all_register': allregisterMap});
      print('user added to all');
    });
    // }catch(e){
    //   return Future.error(e);
    //   //throw AllUsersListFailure();
    // }
  }

  @override
  Future<Map<dynamic, dynamic>> getAllRegistredUsers() async{
    //Map<dynamic, dynamic> allregisterMap = Map();
    var allregisterMap = {};
    try {
      DocumentReference documentReference = _getReference('users').doc('register_users');
      await documentReference.get().then((DocumentSnapshot snapshot) {
        // var data = snapshot.data() as Map;
        // allregisterMap = data['all_register'] as Map;
        allregisterMap = (snapshot.data() as Map)['all_register'] as Map;
        //return allregisterMap;
      });
    } catch (e) {
      throw AllUsersListFailure();
    }
    return allregisterMap;
  }

  @override
  User? getCurrentUser() {
    User? user =   _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<void> signIn({required String email,
    required String password}) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }on Exception{
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future signUp({required String email,
    required String password,
    required String phone}) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = _firebaseAuth.currentUser;
      String phoneN = phone;
      if(phone.length == 11) {
        if(phone.startsWith('8'))
          phoneN = phone.replaceFirst('8', '7');
      }else if(phone.length == 10){
        phoneN = '7' + phone;
      }
      _addUsersData(user!, email, phoneN);
      _addUserToAllRegistred(user, phoneN);
    }on Exception{
      throw SignUpFailure();
    }
  }

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
      throw WishOperationFailure();
    }
  }

  @override
  Future<void> deleteImage(String imgUrl) async{
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.refFromURL(imgUrl);
      await ref.delete();
    }catch(e){
      throw Exception(e);
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
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('users/${_firebaseAuth.currentUser!.uid}/${image.path.split('/').last}');
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() async{
      imgURL = await uploadTask.snapshot.ref.getDownloadURL();
    });
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
      throw WishOperationFailure();
    }
  }

}