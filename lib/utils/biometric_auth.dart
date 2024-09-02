import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
