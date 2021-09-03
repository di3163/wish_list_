import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:wish_list_gx/core.dart';

class ContactServiceException implements Exception {}

class ContactsXController extends GetxController{
  ContactsXController(this._firebaseRepository);

  final AuthRepositoryInterface _firebaseRepository;
  //Rx<List<UserOther>> _userContactList = Rx<List<UserOther>>([]);
  List<UserOther> _userContactList = [];
  PermissionStatus status = PermissionStatus.denied;
  Rx<ContactWidget> contactWidget = Rx<ContactWidget>(EmptyContactWidget());

  //List<UserOther> get contacts => _userContactList;

  checkPermit()async{
    status = await Permission.contacts.status;
    if(!status.isGranted){
      status = await Permission.contacts.request();
    }
  }

  Future<List<Contact>> _getAllContactsFromDevice()async {
    try {
      return (await ContactsService.getContacts(
             withThumbnails: false))
             .toList();
    } catch (e){
      throw ContactServiceException();
    }
  }

  Future<List<UserOther>> _getUserContacts(List<Contact> contactList, Map<dynamic, dynamic> allRegistredUsers)async{
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
            if(phone.startsWith('8'))
              phoneN = phone.replaceFirst('8', '7');
          }
          if(!contactMaps.containsKey(phoneN)){
            if(allRegistredUsers.containsKey(phoneN)) {
              photoURL = await _getPhotoURL(allRegistredUsers[phoneN]);
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

  Future<String> _getPhotoURL(String id)async{
    return await _firebaseRepository.getUserAvatarURL(id);
  }

  getContacts()async {
    await checkPermit();
    if (status.isGranted){
      await _getContacts();
    }else{
      contactWidget(ErrorContactWidget('необходимо разрешение'));
    }
  }


  _getContacts()async {
    contactWidget(LoadingContactWidget());
    if (Get.find<UserProfileController>().
    user.value.userStatus == UserStatus.unauthenticated){
      _userContactList = [];
      contactWidget(ErrorContactWidget('требуется авторизация'));
    }else {
      try {
        final contactList = await _getAllContactsFromDevice();
        final allRegistredUsers = await _firebaseRepository
            .getAllRegistredUsers();
        _userContactList =
            await _getUserContacts(contactList, allRegistredUsers);
        contactWidget(LoadedContactWidget(_userContactList));
      } on Exception {
        contactWidget(ErrorContactWidget('ошибка'));
      }
    }
  }

  @override
  void onInit() async{
      await getContacts();
    super.onInit();
  }
}