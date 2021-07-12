
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsController extends GetxController{
  PermissionStatus status = PermissionStatus.denied;

  Future<void> requestContactsPermit()async{
    status = await Permission.contacts.request();
  }

  Future<PermissionStatus> checkContactPermit()async{
    return await Permission.contacts.status;
  }

  @override
  void onInit() async{
    status  = await checkContactPermit();
    super.onInit();
  }
}