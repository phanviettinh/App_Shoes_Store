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

// Hàm lấy các đơn hàng có trạng thái "Received"
  Future<List<OrderModel>> fetchReceivedOrders() async {
    try {
      // Lấy tất cả các tài liệu người dùng
      final usersSnapshot = await _db.collection('Users').get();

      List<OrderModel> receivedOrders = [];

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

}