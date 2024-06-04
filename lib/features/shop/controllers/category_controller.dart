import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_shoe_store/admin/screen/home/home_admin.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/data/repositories/categories/category_repository.dart';
import 'package:sports_shoe_store/data/repositories/products/product_reposotory.dart';
import 'package:sports_shoe_store/features/shop/models/category_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';

class CategoryController extends GetxController{
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  final image = TextEditingController();
  final RxBool isFeatured = false.obs;
    final name = TextEditingController();
  final parentId = TextEditingController();
  final id = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  final RxString selectedCategoryId = ''.obs;

  final RxList<CategoryModel> allCategory = <CategoryModel>[].obs;
  RxList<CategoryModel> filteredCategories = <CategoryModel>[].obs; // Added
  TextEditingController searchController = TextEditingController(); // Added

  @override
  void onInit() {
    listenToCategories();

    super.onInit();
  }

  /// Listen to category data changes
  void listenToCategories() {
    _categoryRepository.getCategoryStream().listen((categories) {
      allCategories.assignAll(categories);
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList(),);
      filteredCategories.assignAll(allCategories); // Initialize filteredCategories
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    });
  }

    Future<List<CategoryModel>> fetchAllCategoryNotIsFeatured() async{
    try{
      //fetch products
      final category = await _categoryRepository.getAllCategories();
      return category;
    }catch(e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  Future<List<CategoryModel>> fetchCategoryByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await _categoryRepository.fetchCategoryByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
  /// load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// get category or sub-category products
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async{
    try{
      final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit: limit);
      return products;
    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

 ///add category
  Future<void> saveCategory() async {
    final category = CategoryModel(id: id.text, name: name.text, image: image.text, isFeatured: isFeatured.value,parentId: parentId.text);

    try {
      await _categoryRepository.addCategory(category);
      Get.snackbar('Success', 'Category added successfully');
      Get.offAll(() => const HomeScreenAdmin());
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }

  ///load picker
  Future<void> pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Categories/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      image.text = downloadUrl;
    }
  }

  void showCategoryPickerDialog(BuildContext context) {
    final categoriesWithEmptyParentId = CategoryController.instance.allCategories
        .where((category) => category.parentId.isEmpty)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...categoriesWithEmptyParentId.map((category) {
                  return ListTile(
                    leading: Image.network(category.image, width: 50, height: 50),
                    title: Text(category.name),
                    onTap: () {
                      parentId.text = category.id;
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
                const Divider(),
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ListTile(
                     leading: const Icon(Icons.clear),
                     title: const Text('No'),
                     onTap: () {
                       parentId.text = '';
                       Navigator.of(context).pop();
                     },
                   )
                 ],
               ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Filter categories by name
  void filterCategory(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(allCategories);
    } else {
      filteredCategories.assignAll(allCategories.where((category) => category.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void resetCategory() {
    id.clear();
    image.clear();
    name.clear();
    isFeatured.value = false;
    parentId.clear();

  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoryRepository.deleteCategory(categoryId);
      featuredCategories.removeWhere((category) => category.id == categoryId);
      Get.offAll(() => const HomeScreenAdmin());
      Get.snackbar('Success', 'Category deleted successfully');

    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  void setCategoryData(CategoryModel category) {
    image.text = category.image;
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    parentId.text = category.parentId;
  }

  void resetCategoryData() {
    image.clear();
    name.clear();
    isFeatured.value = false;
    parentId.clear();
  }


  Future<void> updateCategoryData(CategoryModel category) async {
    final categoryId = selectedCategoryId.value = category.id;

    final data =  {
      'Image': image.text,
      'Name': name.text,
      'IsFeatured': isFeatured.value,
      'ParentId': parentId.text,
    };


    await _categoryRepository.updateCategory(categoryId, data);
    Get.offAll(() => const HomeScreenAdmin());
    Get.snackbar('Success', 'Category updated successfully');

  }
}