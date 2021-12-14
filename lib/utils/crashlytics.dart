
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseCrash{

  FirebaseCrash._();

  static Future<void> error(
      dynamic error,
      StackTrace? stack,
      dynamic reason,
      bool isFatal
      ) async{
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          reason: reason,
        fatal: isFatal
        // Pass in 'fatal' argument
        );
    }

  static Future<void> errorN({
      required dynamic error,
      StackTrace? stack,
      required dynamic reason,
      required bool isFatal}
      ) async{
    await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: isFatal
      // Pass in 'fatal' argument
    );
  }

    static Future<void> log(String msg)async{
      await FirebaseCrashlytics.instance.log(msg);
    }
}