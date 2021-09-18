import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/controllers/user_profile_controller.dart';

class AllUsersListFailure implements Exception {}
class LogInWithEmailAndPasswordFailure implements Exception {}
class LogInWithPhoneFailure implements Exception {}
class SignUpFailure implements Exception {}
class UserOperationFailure implements Exception {}

abstract class AuthRepositoryInterface {

  Future<Map<dynamic, dynamic>> getAllRegistredUsers();

  Future signUp({
    required String email,
    required String password,
    required String phone});

  Future<void> signUpWithSMSCode({
    required String smsCode});

  Future signIn({
    required String email,
    required String password});

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required String email});

  Future signOut();

  Future<void> updateUserProfile(String photoURL);

  getCurrentUser();

  Future<String> getUserAvatarURL(String id);
  Future<String> saveImage(File image);
  Future deleteImage(String imgUrl);

}

class FirebaseAuthRepository extends AuthRepositoryInterface{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';
  String _phoneNumber = '';
  String _email = '';

  CollectionReference _getReference(String collection){
    return FirebaseFirestore.instance.collection(collection);
  }

  Future<void> _addUsersData(User user, String email, String phone)async {
    CollectionReference ref = _getReference('users');
    ref.doc(user.uid).set({
      'name': email,
      'email': email,
      'phone' :  phone,
      'photoURL': ''
    });
  }

  @override
  Future<String> getUserAvatarURL(String id)async{
    String userData = '';
    try {
      DocumentReference documentReference = _getReference('users').doc(id);
      await documentReference.get().then((DocumentSnapshot snapshot) {
        userData = (snapshot.data() as Map)['photoURL'] ?? '';
      });
    }catch(e) {
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
  Future signUp({
    required String email,
    required String password,
    required String phone}) async{

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = _firebaseAuth.currentUser;
      _addUsersData(user!, email, phone);
      _addUserToAllRegistred(user, phone);
    }on Exception{
      throw SignUpFailure();
    }
  }

  @override
  Future<void> signUpWithSMSCode({required String smsCode}) async{
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);
      UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      User? user = _firebaseAuth.currentUser;
      if(authResult.additionalUserInfo!.isNewUser){
        _addUsersData(user!, _email, _phoneNumber);
        _addUserToAllRegistred(user, _phoneNumber);
      }
     // _addMail(email, user!.uid);
    }on Exception{
      throw SignUpFailure();
    }
  }

  @override
  Future<void> verifyPhoneNumber({required String phoneNumber, required String email}) async{
    try{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        timeout: const Duration(seconds: 3),
        verificationCompleted: (authCredential) => _verificationComplete(authCredential, phoneNumber, email),
        // if there is an exception, get the exception message and set it to the return value
        verificationFailed: (authException) => _verificationFailed(authException),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, int? resendToken) => _smsCodeSent(verificationId, phoneNumber, email));
    }
    //on FirebaseAuthException catch (e)
    on Exception {
      // print('Failed with error code: ${e.code}');
      // print(e.message);
      LogInWithPhoneFailure();
    }
  }

  _verificationComplete(AuthCredential authCredential, String phoneNumber, String email) async{
     //FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {});
     UserCredential authResult = await _firebaseAuth.signInWithCredential(authCredential);
     _phoneNumber = phoneNumber;
     _email = email;
     User? user = _firebaseAuth.currentUser;
     if(authResult.additionalUserInfo!.isNewUser){
       _addUsersData(user!, _email, _phoneNumber);
       _addUserToAllRegistred(user, _phoneNumber);
     }
     if(user != null) {
       //print('user - ${user.uid}');
       Get.find<UserProfileController>().autoVerification();
     }

  }

  void _smsCodeSent(String verificationId, String phoneNumber, String email) {
    // set the verification code so that we can use it to log the user in
    _verificationId = verificationId;
    _phoneNumber = phoneNumber;
    _email = email;
  }

  String _verificationFailed(FirebaseAuthException authException) {
    return authException.message.toString();
  }

  void _codeAutoRetrievalTimeout(String verificationCode) {
    // set the verification code so that we can use it to log the user in
    _verificationId = verificationCode;
    //debugPrint("verify=" + this._verificationCode);
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