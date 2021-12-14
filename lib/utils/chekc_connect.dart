
import 'package:connectivity/connectivity.dart';

class CheckConnect{

  CheckConnect._();

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }
}