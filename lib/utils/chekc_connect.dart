
import 'package:connectivity/connectivity.dart';

class CheckConnect{
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
  }
}