import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:wish_list_gx/core.dart';

class ContactsXController extends GetxController{
  final FirebaseRepository _firebaseRepository = Get.find<FirebaseRepository>();
  //List<UserContact> userContactList = <UserContact>[].obs;
  Rx<List<UserContact>> userContactList = Rx<List<UserContact>>([]);
  PermissionStatus status = PermissionStatus.denied;
  var errorStatus = ''.obs;
  List<UserContact> get contacts => userContactList.value;

  requestContactsPermit()async{
    status = await Permission.contacts.request();
    // if(status.isGranted){
    //   await getContacts();
    //   //get contacts
    // }else {
    //   update();
    // }
  }

  Future<PermissionStatus> checkContactPermit()async{
    return await Permission.contacts.status;
  }

  checkPermit()async{
    status  = await checkContactPermit();
    if(!status.isGranted){
      status = requestContactsPermit();
    }
  }

  Future<List<Contact>> _getAllContactsFromDevice()async {
    List<Contact> contactList = [];
    try {
      var contacts = (await ContactsService.getContacts(
          withThumbnails: false))
          .toList();
      contactList = contacts;
    } catch (e){
      throw ContactServiceException();
    }
    return contactList;
  }

  List<UserContact> _getUserContacts(List<Contact> contactList, Map<dynamic, dynamic> allRegistredUsers){
    Map<String, UserContact> contactMaps = Map();
    for (Contact element in contactList){
      String email = '';
      String phone = '';
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
          if(!contactMaps.containsKey(phone)){
            if(allRegistredUsers.containsKey(phoneN))
              contactMaps[phone] = UserContact(
                name: element.displayName?? '',
                email: email,
                phone: phone,
                id: allRegistredUsers[phone],
              );
          }
        }
      }
    }
    return contactMaps.entries.map((entry) => entry.value).toList();
  }

  getContacts()async {
    errorStatus.value = '';
    try {
      final contactList = await _getAllContactsFromDevice();
      final allRegistredUsers = await _firebaseRepository.getAllRegistredUsers();
      userContactList.value = _getUserContacts(contactList, allRegistredUsers);
    }on Exception{
      errorStatus.value = 'ошибка';
      //return Future.error('error');
    }
  }



  @override
  void onInit() async{
    //status  = await checkContactPermit();
    await checkPermit();
    if(status.isGranted){
      await getContacts();
      //get contacts
    }
    super.onInit();
  }
}