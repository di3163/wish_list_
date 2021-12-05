import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';

import 'package:wish_list_gx/core.dart';


abstract class AuthRepositoryInterface implements
    FetchAllRegistredUsers,
    SignUpWithSMSCode,
    VerifyPhoneNumber,
    UpdateUserProfile,
    ImageOperations,
    FetchUserAvatarURL {

  //Future<RequestBody> fetchAllRegistredUsers();

  // Future<void> signUpWithSMSCode({
  //   required String smsCode});

  // Future verifyPhoneNumber({
  //   required String phoneNumber,
  //   required String email});

  Future signOut();

  // Future<void> updateUserProfile(String photoURL);

  currentUser();

  // Future<String> fetchUserAvatarURL(String id);
  // Future<String> saveImage(File image);
  // Future deleteImage(String imgUrl);
}

typedef FunctionDocReference = DocumentReference Function(String docName);

class FirebaseAuthRepository implements AuthRepositoryInterface{

  static final FirebaseAuthRepository _firebaseAuthRepository = FirebaseAuthRepository._internal();

  factory FirebaseAuthRepository(){
    return _firebaseAuthRepository;
  }

  FirebaseAuthRepository._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId = '';
  String _phoneNumber = '';
  String _email = '';

  DocumentReference _usersDocRef(String docName){
    return FirebaseFirestore.instance.collection('users').
      doc(docName);
  }

  Future<void> _addUsersData(
      User user,
      String email,
      String phone,
      FunctionDocReference docReference
      )async {
    //CollectionReference ref = _fetchReference('users');
    //ref.doc(user.uid).set({
    docReference(user.uid).set({
      'name': email,
      'email': email,
      'phone' :  phone,
      'photoURL': ''
    });
  }

  @override
  Future<String> fetchUserAvatarURL(String id)async{
    String userData = '';
    try {

      //DocumentReference documentReference = _fetchReference('users').doc(id);
      //await documentReference.get().then((DocumentSnapshot snapshot) {
      await _usersDocRef(id).get().then((DocumentSnapshot snapshot) {
        userData = (snapshot.data() as Map)['photoURL'] ?? '';
      });
    }catch(e) {
      return Future.error(e);
    }
    return userData;
  }

  Future<void> _addUserAvatar(
      String id,
      String photoURL,
      FunctionDocReference docReference
      )async{
    //DocumentReference documentReference = _fetchReference('users').doc(id);
    //await documentReference.update(
        await docReference(id).update(
          {
            'photoURL': photoURL
        }
        );
  }

  Future<void> _addUserToAllRegistred(
      User user,
      String phone,
      FunctionDocReference docReference
      ) async {
    //DocumentReference documentReference = _fetchReference('users').doc('register_users');
        var documentReference = docReference('register_users');

        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(documentReference);
          var data = snapshot.data() as Map;
          RequestBody allregisterMap = data['all_register'] as RequestBody;
          allregisterMap[phone] = user.uid;
          transaction.update(documentReference, {'all_register': allregisterMap});
        });
  }

  @override
  Future<RequestBody> fetchAllRegistredUsers() async{
    RequestBody allregisterMap = {};
    //DocumentReference documentReference = _fetchReference('users').doc('register_users');
    var documentReference = _usersDocRef('register_users');
    await documentReference.get().then((DocumentSnapshot snapshot) {
        allregisterMap = (snapshot.data() as Map)['all_register'] as RequestBody;
    }).catchError((e) {
        throw AllUsersListFailure(e.toString());
    });
    return allregisterMap;
  }

  @override
  User? currentUser() {
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
        _addUsersData(user!, _email, _phoneNumber, _usersDocRef);
        _addUserToAllRegistred(user, _phoneNumber, _usersDocRef);
      }
    }catch(e) {
      return Future.error(e);
    }
  }

  @override
  Future verifyPhoneNumber({required String phoneNumber, required String email}) async{
    try{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+$phoneNumber',
        timeout: const Duration(seconds: 5),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, phoneNumber, email),
        verificationFailed: (authException) => _verificationFailed(authException),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        codeSent: (verificationId, int? resendToken) => _smsCodeSent(verificationId, phoneNumber, email)
    );
    } catch (e){
      return Future.error(e);
    }
  }

  _verificationComplete(AuthCredential authCredential, String phoneNumber, String email) async{
     UserCredential authResult = await _firebaseAuth.signInWithCredential(authCredential);
     _phoneNumber = phoneNumber;
     _email = email;
     User? user = _firebaseAuth.currentUser;
     if(authResult.additionalUserInfo!.isNewUser){
       _addUsersData(user!, _email, _phoneNumber, _usersDocRef);
       _addUserToAllRegistred(user, _phoneNumber, _usersDocRef);
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
    Get.find<UserProfileController>().verificationFiled(authException);
  }

  void _codeAutoRetrievalTimeout(String verificationCode) {
    _verificationId = verificationCode;
  }

  @override
  Future<String> saveImage(File image) async{
    String imgURL = '';
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
      return Future.error(e);
    }
    return imgURL;
  }

  @override
  Future<void> updateUserProfile(String photoURL)  async {
    User? user = currentUser();
    if(user != null) {
      try {
        user.updatePhotoURL(photoURL);
        _addUserAvatar(user.uid, photoURL, _usersDocRef);
      }catch(e){
        return Future.error(e);
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
      return Future.error(e);
    }
  }


}

// class MockAuthRepository extends AuthRepositoryInterface{
//
//   String _phoneNumber = '';
//   String _email = '';
//   late final FirebaseAuth _firebaseAuth;
//
//   @override
//   Future deleteImage(String imgUrl) {
//
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Map> getAllRegistredUsers() async{
//     return <dynamic, dynamic>{};
//   }
//
//   @override
//   User? getCurrentUser() {
//     User? user =   _firebaseAuth.currentUser;
//     return user;
//   }
//
//   @override
//   Future<String> getUserAvatarURL(String id) async{
//     return '';
//   }
//
//   @override
//   Future<String> saveImage(File image) async{
//     return '';
//   }
//
//   @override
//   Future signIn({required String email, required String password}) {
//
//     throw UnimplementedError();
//   }
//
//   @override
//   Future signOut() {
//     return _firebaseAuth.signOut();
//   }
//
//   @override
//   Future signUp({required String email, required String password, required String phone}) {
//
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> signUpWithSMSCode({required String smsCode})async {
//     final googleSignIn = MockGoogleSignIn();
//     final signinAccount = await googleSignIn.signIn();
//     final googleAuth = await signinAccount!.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final user = MockUser(
//       isAnonymous: false,
//       uid: 'qu8HX5C4c1XSJHam259u2BKCgyu1',
//       email: 'merida-di@yandex.ru',
//       displayName: 'merida-di@yandex.ru',
//       photoURL: ''
//     );
//     _firebaseAuth = MockFirebaseAuth(mockUser: user);
//     await _firebaseAuth.signInWithCredential(credential);
//   }
//
//   @override
//   Future<void> updateUserProfile(String photoURL) async{
//     User? user = getCurrentUser();
//   }
//
//   @override
//   Future<void> verifyPhoneNumber({required String phoneNumber, required String email}) async {
//     _phoneNumber = phoneNumber;
//     _email = email;
//   }
// }