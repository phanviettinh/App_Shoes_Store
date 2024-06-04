import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_shoe_store/admin/screen/home/home_admin.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/data/repositories/brands/brand_repository.dart';
import 'package:sports_shoe_store/data/repositories/products/product_reposotory.dart';
import 'package:sports_shoe_store/features/shop/models/brand_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';

class BrandController extends GetxController{
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  final id = TextEditingController();
  final image = TextEditingController();
  final name = TextEditingController();
  final RxBool isFeatured = false.obs;
  final productsCount = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxString selectedCategoryId = ''.obs;

  TextEditingController searchController = TextEditingController(); // Added
  final RxList<BrandModel> allBrand = <BrandModel>[].obs;
  RxList<BrandModel> filteredBrands = <BrandModel>[].obs; // Added

  @override
  void onInit() {
    listenToCategories();
    super.onInit();
  }
  ///load brands
  void listenToCategories() {
    brandRepository.getCategoryStream().listen((categories) {
      allBrands.assignAll(categories);
      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4));
      filteredBrands.assignAll(allBrands); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }

  ///get brands for category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async{
    try{
      final brands = await brandRepository.getBrandForCategory(categoryId);
      return brands;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      return [];
    }
  }

  ///get brands specific products from your data source
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async{
    try{
      final products = await ProductRepository.instance.getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      return [];
    }
  }


  Future<void> pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Brands/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      image.text = downloadUrl;
    }
  }

  /// search brands by name
  void filterBrand(String query) {
    if (query.isEmpty) {
      filteredBrands.assignAll(allBrands);
    } else {
      filteredBrands.assignAll(allBrands.where((category) => category.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  ///update
  Future<void> updateBrandData(BrandModel brand) async {
    final brandId = selectedCategoryId.value = brand.id;

    final data =  {
      'Id': id.text,
      'Image': image.text,
      'Name': name.text,
      'IsFeatured': isFeatured.value,
      'ProductsCount': productsCount.text,
    };


    await brandRepository.updateBrand(brandId, data);
    Get.offAll(() => const HomeScreenAdmin());
    Get.snackbar('Success', 'Brand updated successfully');

  }

  ///add category
  Future<void> saveBrand() async {
    final brand = BrandModel(id: id.text, name: name.text, image: image.text, isFeatured: isFeatured.value,productsCount: 1,
    );

    try {
      await brandRepository.addBrand(brand);
      Get.snackbar('Success', 'Brand added successfully');
      Get.offAll(() => const HomeScreenAdmin());
    } catch (e) {
      Get.snackbar('Error', 'Failed to add brand: $e');
    }
  }

  void setBrandData(BrandModel brand) {
    image.text = brand.image;
    name.text = brand.name;
    isFeatured.value = brand.isFeatured!;
    productsCount.text = brand.productsCount.toString();
  }

  void resetBrandData() {
    image.clear();
    name.clear();
    isFeatured.value = false;
    productsCount.clear();
  }
}