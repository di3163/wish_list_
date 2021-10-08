import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:wish_list_gx/core.dart';

class ContactServiceException implements Exception {
  final String? msg;
  const ContactServiceException([this.msg]);
}

class ContactsXController extends GetxController{
  ContactsXController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  //List<UserOther> _userContactList = [];
  PermissionStatus contactsPermissionStatus = PermissionStatus.denied;
  Rx<ContactWidget> contactWidget = Rx<ContactWidget>(EmptyContactWidget());

  checkPermit()async{
    contactsPermissionStatus = await Permission.contacts.status;
    if(!contactsPermissionStatus.isGranted){
      contactsPermissionStatus = await Permission.contacts.request();
    }
  }

  Future<List<Contact>> _fetchAllContactsFromDevice()async {
    try {
      return (await ContactsService.getContacts(
             withThumbnails: false))
             .toList();
    } catch (e){
      throw ContactServiceException(e.toString());
    }
  }

  Future<List<UserOther>> _fetchUserContacts(List<Contact> contactList, Map<dynamic, dynamic> allRegistredUsers)async{
    Map<String, UserOther> contactMaps = {};
    for (Contact element in contactList){
      String email = '';
      String phone = '';
      String photoURL = '';
      if(element.emails!.isNotEmpty){
        List<Item> emailes = element.emails!.toList();
        email = emailes[0].value!;
      }
      if(element.phones!.isNotEmpty){
        List<Item> phones = element.phones!.toList();
        for(Item phoneElement in phones){
          phone = phoneElement.value.toString().replaceAll(RegExp(r'[^\d]'), '');
          String phoneN = phone;
          if (phone.length == 11) {
            if(phone.startsWith('8')) {
              phoneN = phone.replaceFirst('8', '7');
            }
          }
          if(!contactMaps.containsKey(phoneN)){
            if(allRegistredUsers.containsKey(phoneN)) {
              photoURL = await _fetchPhotoURL(allRegistredUsers[phoneN]);
              contactMaps[phoneN] =
                  UserOther.fromJson(
                      {
                        "id": allRegistredUsers[phoneN],
                        "userStatus": UserStatus.other,
                        "name": element.displayName ?? '',
                        "email": email,
                        "phone": phoneN,
                        "photoURL": photoURL
                      }
                  );
            }
          }
        }
      }
    }
    return contactMaps.entries.map((entry) => entry.value).toList();
  }

  Future<String> _fetchPhotoURL(String id)async{
    String photoURL = '';
    try {
      photoURL = await _firebaseRepository.fetchUserAvatarURL(id);
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_photo_url'.tr, false);
      //SnackbarGet.showSnackBar('err'.tr);
    }
    return photoURL;

  }

  Future<void> updateContactWidget()async {
    //await checkPermit();
    if (!contactsPermissionStatus.isGranted) {
      contactWidget(ErrorContactWidget('permit_req'.tr));
    }else if(Get.find<UserProfileController>().
        user.value.userStatus == UserStatus.unauthenticated){
      contactWidget(ErrorContactWidget('auth_req'.tr));
    }else{
      contactWidget(LoadingContactWidget());
      try {

        List<UserOther> userContactList = await _fetchContacts();
        contactWidget(LoadedContactWidget(userContactList));
        //throw ContactServiceException('eine Warnung');
      }on ContactServiceException{
        FirebaseCrash.log('contact_service_err'.tr);
        contactWidget(ErrorContactWidget('err'.tr));
      }catch(e, s){
        await FirebaseCrash.error(e, s, 'err'.tr, false);
      }
    }
  }


  // _getContactsOld()async {
  //   contactWidget(LoadingContactWidget());
  //   if (Get.find<UserProfileController>().
  //   user.value.userStatus == UserStatus.unauthenticated){
  //     _userContactList = [];
  //     contactWidget(ErrorContactWidget('auth_req'.tr));
  //   }else {
  //     try {
  //       final contactList = await _getAllContactsFromDevice();
  //       final allRegistredUsers = await _firebaseRepository
  //           .getAllRegistredUsers();
  //       _userContactList =
  //           await _getUserContacts(contactList, allRegistredUsers);
  //       contactWidget(LoadedContactWidget(_userContactList));
  //     } on Exception {
  //       contactWidget(ErrorContactWidget('err'.tr));
  //     }
  //   }
  // }

  Future<List<UserOther>> _fetchContacts()async {
    List<UserOther> userContactList = [];
    try{
      final contactList = await _fetchAllContactsFromDevice();
      final allRegistredUsers = await _firebaseRepository
          .fetchAllRegistredUsers();
      userContactList = await _fetchUserContacts(contactList, allRegistredUsers);
    } catch(e){
      //print(e.toString());
      throw ContactServiceException(e.toString());
    }
    return userContactList;
  }

  @override
  void onInit() async{
    await checkPermit();
    await updateContactWidget();
    super.onInit();
  }
}