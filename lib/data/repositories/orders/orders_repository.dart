import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/features/shop/models/order_model.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';

class OrderRepository extends GetxController{
  static OrderRepository get instance => Get.find();

  ///variable
  final _db = FirebaseFirestore.instance;

  List<OrderModel> temporaryOrders = [];

/// Fetch all orders for all users
  Future<List<OrderModel>> fetchAllUserOrders() async {
    try {
      // Get all user documents
      final usersSnapshot = await _db.collection('Users').get();

      List<OrderModel> allOrders = [];

      // Iterate through each user document to get their orders
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .get();

        // Add each order to the list
        allOrders.addAll(ordersSnapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList());
      }

      return allOrders;
    } catch (e) {
      print('Error fetching all user orders: $e');
      throw 'Something went wrong while fetching all user orders. Try again later';
    }
  }

  ///xoa

  Future<void> deleteOrder(String userId, String orderId) async {
    try {
      // Delete order from the user's subcollection
      await _db.collection('Users').doc(userId).collection('Orders').doc(orderId).delete();
      // Optionally, delete order from the main orders collection if it exists there
      await _db.collection('Orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
      throw 'Failed to delete order';
    }
  }

  ///get order related to current user
  Future<List<OrderModel>> fetchUserOrders() async{
    try{
      final userId = AuthenticationRepository.instance.authUser.uid;
      if(userId.isEmpty) throw 'Unable to find user information. Try again in few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    }catch(e){
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }
  Future<List<OrderModel>> fetchUserOrders2(String userId) async {
    try {
      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }
  // New method to fetch all orders for admin
  Future<List<OrderModel>> fetchAllOrders() async {

      // Lấy dữ liệu trực tiếp từ server
      final result = await _db.collectionGroup('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();

  }


  Future<List<OrderModel>> fetchUserOrdersAdmin(String userId) async {
    try {
      if (userId.isEmpty) throw 'Unable to find user information. Try again in a few minutes.';

      final result = await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong while fetching order information. Try again later';
    }
  }



  //save and update orders
  Future<String> saveOrUpdateOrder(OrderModel order, String clientUserId) async {
    try {
      final orderRef = _db.collection('Users').doc(clientUserId).collection('Orders');

      // Kiểm tra xem đơn hàng đã tồn tại hay chưa
      final querySnapshot = await orderRef.where('id', isEqualTo: order.id).get();
      if (querySnapshot.docs.isEmpty) {
        // Nếu đơn hàng chưa tồn tại, thêm mới đơn hàng
        final docRef = await orderRef.add(order.toJson());
        return docRef.id;
      } else {
        // Nếu đơn hàng đã tồn tại, cập nhật đơn hàng
        final orderId = querySnapshot.docs.first.id;
        await orderRef.doc(orderId).update(order.toJson());
        return orderId;
      }
    } catch (e) {
      throw 'Failed to save or update order: $e';
    }
  }

  Future<List<OrderModel>> fetchReceivedOrders() async {
    try {
      List<OrderModel> receivedOrders = [];

      // Nếu có các đơn đặt hàng tạm thời, thêm chúng vào danh sách
      if (temporaryOrders.isNotEmpty) {
        receivedOrders.addAll(temporaryOrders.where((order) => order.status == OrderStatus.received));
      }

      // Lấy tất cả các tài liệu người dùng
      final usersSnapshot = await _db.collection('Users').get();

      // Lặp qua từng tài liệu người dùng để tìm đơn hàng có trạng thái "Received"
      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('Orders')
            .where('status', isEqualTo: 'OrderStatus.received')
            .get();

        // Thêm các đơn hàng có trạng thái "Received" vào danh sách
        receivedOrders.addAll(ordersSnapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList());
      }

      return receivedOrders;
    } catch (e) {
      print('Error fetching received orders: $e'); // In lỗi chi tiết
      throw 'Something went wrong while fetching received orders. Try again later';
    }
  }

  // Phương thức để thêm đơn đặt hàng vào biến tạm thời
  void addTemporaryOrders(List<OrderModel> orders) {
    temporaryOrders.addAll(orders);
  }
}