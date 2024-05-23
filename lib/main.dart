
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
 ///add widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  ///GetX Local storage
  await GetStorage.init('');

  ///splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  ///--Initialize firebase authentication repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  Get.lazyPut(() => CartController(), fenix: true);  // Ensure CartController is always available



  runApp(const App());
}
