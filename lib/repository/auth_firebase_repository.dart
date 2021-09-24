import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';



import 'package:wish_list_gx/core.dart';

class AllUsersListFailure implements Exception {}

abstract class AuthRepositoryInterface {

  Future<Map<dynamic, dynamic>> getAllRegistredUsers();

  Future<void> signUpWithSMSCode({
    required String smsCode});

  Future verifyPhoneNumber({
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
      return Future.error('err_img_load'.tr);
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
    DocumentReference documentReference = _getReference('users').doc('register_users');
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      var data = snapshot.data() as Map;
      Map<String, dynamic> allregisterMap = data['all_register'] as Map<String, dynamic>;
      allregisterMap[phone] = user.uid;
      transaction.update(documentReference, {'all_register': allregisterMap});
    });
  }

  @override
  Future<Map<dynamic, dynamic>> getAllRegistredUsers() async{
    var allregisterMap = {};
    DocumentReference documentReference = _getReference('users').doc('register_users');
    await documentReference.get().then((DocumentSnapshot snapshot) {
        allregisterMap = (snapshot.data() as Map)['all_register'] as Map;
    }).catchError((e) {
        throw AllUsersListFailure();
    });
    return allregisterMap;
  }

  @override
  User? getCurrentUser() {
    User? user =   _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future signOut() {
    return _firebaseAuth.signOut();
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
    }catch(e) {
      return Future.error('err_auth'.tr);
    }
  }

  @override
  Future verifyPhoneNumber({required String phoneNumber, required String email}) async{
    try{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        timeout: const Duration(seconds: 3),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, phoneNumber, email),
        // if there is an exception, get the exception message and set it to the return value
        verificationFailed: (authException) => _verificationFailed(authException),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, int? resendToken) => _smsCodeSent(verificationId, phoneNumber, email)
    );
    } catch (e){
      return Future.error('err_auth'.tr);
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
       Get.find<UserProfileController>().autoVerification();
     }
  }

  void _smsCodeSent(String verificationId, String phoneNumber, String email) {
    _verificationId = verificationId;
    _phoneNumber = phoneNumber;
    _email = email;
  }

  void _verificationFailed(FirebaseAuthException authException) {
    Get.find<UserProfileController>().showSnackBar(authException.code);
  }

  void _codeAutoRetrievalTimeout(String verificationCode) {
    // set the verification code so that we can use it to log the user in
    _verificationId = verificationCode;
  }

  @override
  Future<String> saveImage(File image) async{
    String imgURL = '';
    //FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference ref = FirebaseStorage.instance.ref().
      child('users/${_firebaseAuth.currentUser!.uid}/${image.path
          .split('/')
          .last}');
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
  Future<void> updateUserProfile(String photoURL)  async {
    User? user = getCurrentUser();
    if(user != null) {
      try {
        user.updatePhotoURL(photoURL);
        _addUserAvatar(user.uid, photoURL);
      }catch(e){
        return Future.error('err'.tr);
      }
    }
  }

  @override
  Future deleteImage(String imgUrl) async{
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.refFromURL(imgUrl);
      await ref.delete();
    }catch(e){
      return Future.error('err'.tr);
    }
  }


}

class MockAuthRepository extends AuthRepositoryInterface{

  String _phoneNumber = '';
  String _email = '';
  late final FirebaseAuth _firebaseAuth;

  @override
  Future deleteImage(String imgUrl) {
    // TODO: implement deleteImage
    throw UnimplementedError();
  }

  @override
  Future<Map> getAllRegistredUsers() async{
    return <dynamic, dynamic>{};
  }

  @override
  User? getCurrentUser() {
    User? user =   _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<String> getUserAvatarURL(String id) async{
    return '';
  }

  @override
  Future<String> saveImage(File image) async{
    return '';
  }

  @override
  Future signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future signUp({required String email, required String password, required String phone}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> signUpWithSMSCode({required String smsCode})async {
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = MockUser(
      isAnonymous: false,
      uid: 'qu8HX5C4c1XSJHam259u2BKCgyu1',
      email: 'merida-di@yandex.ru',
      displayName: 'merida-di@yandex.ru',
      photoURL: ''
    );
    _firebaseAuth = MockFirebaseAuth(mockUser: user);
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> updateUserProfile(String photoURL) async{
    User? user = getCurrentUser();
  }

  @override
  Future<void> verifyPhoneNumber({required String phoneNumber, required String email}) async {
    _phoneNumber = phoneNumber;
    _email = email;
  }
}