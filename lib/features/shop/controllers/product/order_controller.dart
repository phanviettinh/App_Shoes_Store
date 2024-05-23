import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/screen/home/home_admin.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/common/widgets/succes_screen/succes_screen.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/data/repositories/orders/orders_repository.dart';
import 'package:sports_shoe_store/features/personalization/controllers/address_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/checkout_controller.dart';
import 'package:sports_shoe_store/features/shop/models/order_model.dart';
import 'package:sports_shoe_store/features/shop/screens/order/order_detail.dart';
import 'package:sports_shoe_store/navigation_menu.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/popups/full_screen_loader.dart';

class OrderController extends GetxController{
  static OrderController get instance => Get.find();

  ///variable
  final cartController = Get.put(CartController()); // Use Get.find() to get the CartController instance
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());
  var orders = <OrderModel>[].obs;
    var receivedOrdersCount = 0.obs;
  var totalProfit = 0.0.obs;
  var showTotalAmount = false.obs; // Thêm biến này

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

  ///
  Future<List<OrderModel>> fetAllUserOrders() async{
    try{
      final allOrders = await orderRepository.fetchAllOrders();
      orders.value = allOrders;
      return allOrders;
    }catch(e){
      TLoaders.warningSnackBar(title: 'Oh Snap!',message: e.toString());
      return[];
    }
  }
  ///lay cac hoa don da nhan
  void fetchReceivedOrders() async {
    try {
      final orders = await orderRepository.fetchReceivedOrders();
      receivedOrdersCount.value = orders.length;
      totalProfit.value = orders.fold(0.0, (sum, order) => sum + order.totalAmount);
    } catch (e) {
      print('Error in fetchReceivedOrders: $e'); // In lỗi chi tiết
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void processOrder(double totalAmount) async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing your order', TImages.loading);

      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Thêm đơn hàng vào cơ sở dữ liệu với trạng thái "pending"
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 3)), // Thêm 3 ngày vào ngày đặt
        items: cartController.cartItems.toList(),
      );


      // Lưu đơn hàng vào cơ sở dữ liệu và nhận ID của đơn hàng đã được lưu trữ
       await orderRepository.saveOrUpdateOrder(order, userId);

      // Xóa giỏ hàng sau khi đơn hàng được xử lý
      cartController.clearCart();

      // Hiển thị màn hình thành công
      Get.off(() => SuccessScreen(
        image: TImages.checkerSuccess,
        title: 'Payment Success!',
        subtitle: 'Your item will be shipped soon',
        onPressed: () => Get.offAll(() => const NavigationMenu()),
      ));

      // Sau khi lưu đơn hàng, sử dụng ID được trả về để cập nhật đơn hàng nếu cần
      // Ví dụ: await orderRepository.updateOrder(updatedOrder, userId, orderId);
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void cancelledOrder(double totalAmount) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final userOrders = await orderRepository.fetchUserOrders();


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in userOrders) {
        if (order.status == OrderStatus.pending) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.cancelled;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, userId );

          Get.off(() => SuccessScreen(
            image: TImages.checkerSuccess,
            title: 'Cancel Success!',
            subtitle: 'Your Order has been cancelled',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void shippedOrder(String clientUserId, double totalAmount) async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing your order', TImages.loading);

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final clientOrders = await orderRepository.fetchUserOrdersAdmin(clientUserId);

      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "shipped"
      for (final order in clientOrders) {
        if (order.status == OrderStatus.pending) {
          // Cập nhật trạng thái của đơn hàng thành "shipped"
          order.status = OrderStatus.shipped;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, clientUserId);

          Get.off(() => SuccessScreen(
            image: TImages.checkerSuccess,
            title: 'Success!',
            subtitle: 'Thank you very much!',
            onPressed: () => Get.offAll(() => const HomeScreenAdmin()),
          ));

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void receivedOrder(double totalAmount) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Lấy danh sách đơn hàng của người dùng từ cơ sở dữ liệu
      final userOrders = await orderRepository.fetchUserOrders();


      // Tìm đơn hàng có trạng thái "pending" và cập nhật thành "cancelled"
      for (final order in userOrders) {
        if (order.status == OrderStatus.shipped) {
          // Cập nhật trạng thái của đơn hàng thành "cancelled"
          order.status = OrderStatus.received;

          // Thực hiện cập nhật trạng thái mới của đơn hàng
          await orderRepository.saveOrUpdateOrder(order, userId );

          Get.off(() => SuccessScreen(
            image: TImages.checkerSuccess,
            title: 'Success!',
            subtitle: 'Thanks you very much!',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));

          // Thoát khỏi vòng lặp sau khi cập nhật đơn hàng đầu tiên
          break;
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}