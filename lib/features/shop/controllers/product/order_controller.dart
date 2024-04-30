import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/common/widgets/succes_screen/succes_screen.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/data/repositories/orders/orders_repository.dart';
import 'package:sports_shoe_store/features/personalization/controllers/address_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/checkout_controller.dart';
import 'package:sports_shoe_store/features/shop/models/order_model.dart';
import 'package:sports_shoe_store/navigation_menu.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/popups/full_screen_loader.dart';

class OrderController extends GetxController{
  static OrderController get instance => Get.find();

  ///variable
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  ///
  Future<List<OrderModel>> fetUserOrders() async{
    try{
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    }catch(e){
      TLoaders.warningSnackBar(title: 'Oh Snap!',message: e.toString());
      return[];
    }
  }

  ///add method for order processing
  void processOrder(double totalAmount) async{
    try{
      TFullScreenLoader.openLoadingDialog('Processing your order', TImages.underArmour);

      final userId = AuthenticationRepository.instance.authUser.uid;
      if(userId.isEmpty) return;

      //add detail
      final order = OrderModel(
          id: UniqueKey().toString(),
          userId: userId,
          status: OrderStatus.pending,
          totalAmount: totalAmount,
          orderDate: DateTime.now(),
          paymentMethod: checkoutController.selectedPaymentMethod.value.name,
          address: addressController.selectedAddress.value,
          deliveryDate: DateTime.now(),
          items: cartController.cartItems.toList()
      );

      //save the order to fireStore
      await orderRepository.saveOrder(order, userId);

      //update the cart status
      cartController.clearCart();

      //show success screen
      Get.off(() => SuccessScreen(
          image: TImages.checkerSuccess,
          title: 'Payment Success!',
          subtitle: 'Your item will be shipped soon',
          onPressed: () => Get.offAll(() => const NavigationMenu())
      ));

    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}