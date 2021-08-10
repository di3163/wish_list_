// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wish_list_gx/models/wish.dart';
//
//
// class LogInWithEmailAndPasswordFailure implements Exception {}
//
// class AllUsersListFailure implements Exception {}
//
// class SignUpFailure implements Exception {}
//
// class WishOperationFailure implements Exception{}
//
//
// class FirebaseRepository  {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//   CollectionReference _getReference(String collection){
//     return FirebaseFirestore.instance.collection(collection);
//   }
//
//   Future<void> _addUsersData(User user, String email, String phone)async {
//     CollectionReference ref = _getReference('users');
//     ref.doc(user.uid).set({
//       'name': email,
//       //'uid': user.uid,
//       'email': user.email,
//       'phone' :  phone,
//     });
//   }
//
//   Future<void> _addUserToAllRegistred(User user, String phone) async {
//     //TODO возвращать из этого метода allRegisterMap для дальнейшего использования
//     //после создания пользователя
//
//     //try {
//       //DocumentReference documentReference = _getReference('users').doc('all_register_users');
//       DocumentReference documentReference = _getReference('users').doc('register_users');
//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(documentReference);
//         var data = snapshot.data() as Map;
//         Map<String, dynamic> allregisterMap = data['all_register'] as Map<String, dynamic>;
//         allregisterMap[phone] = user.uid;
//         transaction.update(documentReference, {'all_register': allregisterMap});
//         print('user added to all');
//       });
//     // }catch(e){
//     //   return Future.error(e);
//     //   //throw AllUsersListFailure();
//     // }
//   }
//
//
//   Future<Map<dynamic, dynamic>> getAllRegistredUsers() async {
//     Map<dynamic, dynamic> allregisterMap = Map();
//     try {
//       //DocumentReference documentReference = _getReference('users').doc('all_register_users');
//       DocumentReference documentReference = _getReference('users').doc('register_users');
//       await documentReference.get().then((DocumentSnapshot snapshot) {
//         var data = snapshot.data() as Map;
//         allregisterMap = data['all_register'] as Map;
//       });
//     } catch (e) {
//       throw AllUsersListFailure();
//     }
//     return allregisterMap;
//   }
//
//
//   Future<void> addAllUserMockList(Map<String, dynamic> allUsersList)async {
//     CollectionReference ref = _getReference('users');
//     ref.doc('all_register_users').set({
//       'all_register' : allUsersList,
//     });
//   }
//
//
//   Future<void> signUp({required String email, required String password, required String phone}) async{
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//       User? user = _firebaseAuth.currentUser;
//       String phoneN = phone;
//       if(phone.length == 11) {
//         if(phone.startsWith('8'))
//           phoneN = phone.replaceFirst('8', '7');
//       }else if(phone.length == 10){
//         phoneN = '7' + phone;
//       }
//       _addUsersData(user!, email, phoneN);
//       _addUserToAllRegistred(user, phoneN);
//     }on Exception{
//       throw SignUpFailure();
//     }
//   }
//
//   Future<void> signIn({required String email,
//     required String password}) async{
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//     }on Exception{
//       throw LogInWithEmailAndPasswordFailure();
//     }
//   }
//
//   User?  getCurrentUser () {
//     User? user =   _firebaseAuth.currentUser;
//     return user;
//   }
//
//   Future<void> signOut() {
//     return _firebaseAuth.signOut();
//   }
//
//
//   Future<void> addUserWish( Wish wish)async{
//     try {
//       CollectionReference ref = _getReference(getCurrentUser()!.uid);
//       await ref.add({
//         'title': wish.title,
//         'description': wish.description,
//         'link': wish.link,
//         'listImg': wish.listPicURL
//       }
//       );
//     }catch(e){
//       throw WishOperationFailure();
//     }
//   }
//
//   Future<void> updateUserWish(Wish wish)async{
//     try {
//       CollectionReference ref = _getReference(getCurrentUser()!.uid);
//       await ref.doc(wish.id).update(
//         {
//           'title': wish.title,
//           'description': wish.description,
//           'link': wish.link,
//           'listImg': wish.listPicURL
//         }
//       );
//     }catch(e){
//       throw WishOperationFailure();
//     }
//   }
//
//
//   Future<List<Wish>> getUserWish() async{
//     List<Wish> listWish = [];
//     CollectionReference ref = _getReference(getCurrentUser()!.uid);
//     await ref.get().then((QuerySnapshot querySnapshot) =>
//         querySnapshot.docs.forEach((doc) {
//           listWish.add(Wish(title: doc['title'], description: doc['description'], link: doc['link'], listPicURL: doc['listImg'].cast<String>()));
//         }));
//     return listWish;
//   }
//
//   Stream<List<Wish>> getUserWishStream(String userId){
//     String _id = getCurrentUser()!.uid;
//     if (userId != '')
//       _id = userId;
//     try {
//       return _getReference(_id).
//       snapshots().map((QuerySnapshot querySnapshot) {
//         List<Wish> listWish = [];
//         querySnapshot.docs.forEach((element) =>
//             listWish.add(Wish.fromDocumentSnapshot(element))
//         );
//         return listWish;
//       }
//       );
//     }catch(e) {
//       throw WishOperationFailure();
//     }
//   }
//
//   Future<String> saveImage(File image) async{
//     String imgURL = '';
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref = storage.ref().child('users/${getCurrentUser()!.uid}/${image.path.split('/').last}');
//     UploadTask uploadTask = ref.putFile(image);
//     await uploadTask.whenComplete(() async{
//       imgURL = await uploadTask.snapshot.ref.getDownloadURL();
//     });
//     return imgURL;
//   }
//
//   Future<void> deleteImage(String imgUrl) async{
//     try {
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference ref = storage.refFromURL(imgUrl);
//       await ref.delete();
//     }catch(e){
//       throw Exception(e);
//     }
//   }
//
//   void deleteWish(Wish wish)async {
//     CollectionReference ref = _getReference(getCurrentUser()!.uid);
//     await ref.doc(wish.id).delete();
//   }
// }
//
