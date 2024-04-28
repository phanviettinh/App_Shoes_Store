import 'package:get/get.dart';
import 'package:sports_shoe_store/features/authentication/controllers/signup/network_manager.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/variation_controller.dart';

class GeneralBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
  }

}