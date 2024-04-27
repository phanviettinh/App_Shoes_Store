import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/features/shop/models/banner_model.dart';
import 'package:sports_shoe_store/utils/exceptions/firebase_exception.dart';
import 'package:sports_shoe_store/utils/exceptions/format_exception.dart';
import 'package:sports_shoe_store/utils/exceptions/platform_exception.dart';

class BannerRepository extends GetxController{
  static BannerRepository get instance => Get.find();

  ///variable
  final _db =  FirebaseFirestore.instance;


  ///get all order related to current user
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db.collection('Banners').where('Active',isEqualTo: true).get();
      return result.docs.map((documentSnapshot) => BannerModel.fromSnapShot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. please try again';
    }
  }


  ///upload banners to the cloud firebase
}