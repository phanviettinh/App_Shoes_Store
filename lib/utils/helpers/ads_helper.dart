import 'dart:io';

class AdsHelper {
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3738204979027684/9873326136'; // Test Banner iOS
    } else {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test Banner Android
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3738204979027684/1923340464'; // Test Interstitial iOS
    } else {

    return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial Android
    }
  }
}
