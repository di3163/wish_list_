import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AllUsersListFailure implements Exception {}
class LogInWithEmailAndPasswordFailure implements Exception {}
class SignUpFailure implements Exception {}
class UserOperationFailure implements Exception {}

abstract class AuthRepositoryInterface {

  Future<Map<dynamic, dynamic>> getAllRegistredUsers();

  Future signUp({required String email,
    required String password,
    required String phone});

  Future signIn({required String email,
    required String password});

  Future signOut();

  Future<void> updateUserProfile(String photoURL);

  getCurrentUser();

  Future<String> getUserAvatarURL(String id);
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
      'photoURL': ''
    });
  }

  Future<String> getUserAvatarURL(String id)async{
    String userData = '';
    try {
      DocumentReference documentReference = _getReference('users').doc(id);
      await documentReference.get().then((DocumentSnapshot snapshot) {
        userData = (snapshot.data() as Map)['photoURL'] ?? '';
      });
    }catch(e) {
      print(e.toString());
      throw UserOperationFailure();
    }
    return userData;

  }

  Future<void> _addUserAvatar(String id, String photoURL)async{
    DocumentReference documentReference = _getReference('users').doc(id);
    await documentReference.update(
        {
          'photoURL': photoURL
        }
    );
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
      //print('user added to all');
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
  Future<void> updateUserProfile(String photoURL)  async {
    User? user = getCurrentUser();
    if(user != null) {
      user.updatePhotoURL(photoURL);
      _addUserAvatar(user.uid, photoURL);
    }
  }

  @override
  Future deleteImage(String imgUrl) async{
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.refFromURL(imgUrl);
      await ref.delete();
    }catch(e){
      throw Exception(e);
    }
  }
}