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


  ///get all order related to current user
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

  //save and update orders
  Future<String> saveOrUpdateOrder(OrderModel order, String userId) async {
    try {
      final orderRef = _db.collection('Users').doc(userId).collection('Orders');

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


// // Thêm hàm saveOrder để trả về ID của đơn hàng đã được lưu trữ
//   Future<String> saveOrder(OrderModel order, String userId) async {
//     try {
//       final docRef = await _db.collection('Users').doc(userId).collection('Orders').add(order.toJson());
//       return docRef.id; // Trả về ID của tài liệu đã được lưu trữ
//     } catch (e) {
//       throw 'Something went wrong while fetching order information. Try again later';
//     }
//   }

// // Cập nhật đơn hàng sử dụng ID đã cho
//   Future<void> updateOrder(OrderModel order, String userId, String orderId) async {
//     try {
//       // Kiểm tra tính hợp lệ của mã đơn hàng trước khi cập nhật
//       await _db.collection('Orders').doc(userId).collection('Orders').doc(orderId).update(order.toJson());
//
//     } catch (e) {
//       throw 'Failed to update order: $e';
//     }
//   }







}