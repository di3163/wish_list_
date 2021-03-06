import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:wish_list_gx/core.dart';

class ContactServiceException implements Exception {
  final String? msg;
  const ContactServiceException([this.msg]);
}

class ContactsXController extends GetxController{

  late final AuthRepositoryInterface _authRepository;
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

  Future<List<UserOther>> _fetchUserContacts(List<Contact> contactList, Map<String, dynamic> allRegistredUsers)async{
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
                  UserOther(
                      id: allRegistredUsers[phoneN],
                      userStatus: UserStatus.other,
                      photoURL: photoURL,
                      name: element.displayName ?? '',
                      email: email,
                      phone: phoneN);
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
      photoURL = await _authRepository.fetchUserAvatarURL(id);
    }catch(e, s){
      await FirebaseCrash.error(e, s, 'err_photo_url'.tr, false);
      //SnackbarGet.showSnackBar('err'.tr);
    }
    return photoURL;

  }

  Future<void> updateContactWidget()async {
    //await checkPermit();
    if (!contactsPermissionStatus.isGranted) {
      contactWidget(ErrorContactWidget(state: 'permit_req'.tr,));
    }else if(Get.find<UserProfileController>().
        user.value.userStatus == UserStatus.unauthenticated){
      contactWidget(ErrorContactWidget(state: 'auth_req'.tr));
    }else{
      contactWidget(LoadingContactWidget());
      try {

        List<UserOther> userContactList = await _fetchContacts();
        contactWidget(LoadedContactWidget(contacts: userContactList));
        //throw const ContactServiceException('eine Warnung');
      }on ContactServiceException catch(e){
        //FirebaseCrash.log('contact_service_err'.tr);
        await FirebaseCrash.errorN(error: e, reason: e.msg, isFatal: false);
        contactWidget(ErrorContactWidget(state:'err'.tr));
      }catch(e, s){
        await FirebaseCrash.error(e, s, 'err'.tr, false);
        contactWidget(ErrorContactWidget(state:'err'.tr));
      }
    }
  }


  Future<List<UserOther>> _fetchContacts()async {
    List<UserOther> userContactList = [];
    try{
      final contactList = await _fetchAllContactsFromDevice();
      final allRegistredUsers = await _authRepository
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
    _authRepository = Get.find<AuthRepositoryInterface>();
    await checkPermit();
    await updateContactWidget();
    super.onInit();
  }
}