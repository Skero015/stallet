
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalBiometricAuth {

  static final LocalAuthentication localAuth = LocalAuthentication();

  //check biometric features
  static Future<bool> checkBiometrics() async {

    try{
      return await localAuth.canCheckBiometrics && await localAuth.isDeviceSupported();
    }on PlatformException catch(e){
      print(e);
      return false;
    }

  }

  //check available biometrics types
  static Future<List<BiometricType>> getBiometricTypes() async {

    return await localAuth.getAvailableBiometrics();

  }

  //biometric authentication
  static Future<bool> authenticated() async {

    final hasBiometrics = await checkBiometrics();

    if(hasBiometrics) {
      try{
        return await localAuth.authenticate(
          localizedReason: 'Please complete the biometrics to login.',
          biometricOnly: true,
          stickyAuth: true,
        );
      }on PlatformException catch(e) {
        print(e);
        return false;
      }
    }else{
      return false;
    }



  }

}