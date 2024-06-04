import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/screen/home/home_admin.dart';
import 'package:sports_shoe_store/admin/screen/products/show_product_admin.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/data/repositories/products/product_reposotory.dart';
import 'package:sports_shoe_store/features/shop/controllers/category_controller.dart';
import 'package:sports_shoe_store/features/shop/models/brand_model.dart';
import 'package:sports_shoe_store/features/shop/models/category_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_attribute_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_variation_model.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AllProductController extends GetxController {
  static AllProductController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final salePriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final thumbnailController = TextEditingController();
  final categoryIdController = TextEditingController();
  final sku = TextEditingController();

  final Rx<ProductType> selectedProductType = ProductType.single.obs;

  final RxList<TextEditingController> images = <TextEditingController>[].obs;
  final RxBool isFeatured = false.obs;

  ///variation


  final brandIdController = TextEditingController();
  final brandNameController = TextEditingController();
  final brandImageController = TextEditingController();
  final brandProductsCountController = TextEditingController();
  final RxBool brandIsFeatured = false.obs;

  final RxList<ProductAttributeModel> attributes = <ProductAttributeModel>[].obs;
  final RxList<TextEditingController> values = <TextEditingController>[].obs; // For managing attribute values

  final RxList<ProductVariationModel> variations = <ProductVariationModel>[].obs;
  final id = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();

  final color = TextEditingController();
  final size = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final CategoryController categoryController = CategoryController.instance;

  final RxString selectedProductId = ''.obs;



  // Danh sách các tùy chọn hình ảnh
  final List<String> brandImageOptions = [
    'adidas_icon.jpg',
    'converse.jpg',
    'newbalance.jpg',
    'underarmour.jpg',
    'nike.png',
    'puma.png',
    'vans.jpg',
  ];

  final Map<String, String> brandImageToIdMap = {
    'adidas_icon.jpg': '2',
    'converse.jpg': '5',
    'newbalance.jpg': '4',
    'underarmour.jpg': '7',
    'nike.png': '1',
    'puma.png': '3',
  };


  final Map<String, String> brandImageToNameMap = {
    'adidas_icon.jpg': 'Adidas',
    'converse.jpg': 'Converse',
    'newbalance.jpg': 'New Balance',
    'underarmour.jpg': 'Under Armour',
    'nike.png': 'Nike',
    'puma.png': 'Puma',
  };

  void showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Brand Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: brandImageOptions.map((imageName) {
                return ListTile(
                  leading: Image.asset('assets/icons/brands/$imageName', width: 50, height: 50),
                  title: Text(imageName),
                  onTap: () {
                    final localImagePath = 'assets/icons/brands/$imageName';
                    final brandId = brandImageToIdMap[imageName];
                    final brandName = brandImageToNameMap[imageName];
                    brandImageController.text = localImagePath;
                    brandIdController.text = brandId!;
                    brandNameController.text = brandName!;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void showCategoryPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categoryController.allCategories.map((category) {
                return ListTile(
                  leading: Image.network(category.image, width: 50, height: 50),
                  title: Text(category.name),
                  onTap: () {
                    categoryIdController.text = category.id;
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void addImage() {
    images.add(TextEditingController());
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void addValue(int attributeIndex) {
    attributes[attributeIndex].values?.add('');
  }

  void removeValue(int attributeIndex, int valueIndex) {
    attributes[attributeIndex].values?.removeAt(valueIndex);
  }

  void addAttribute() {
    attributes.add(ProductAttributeModel(name: '', values: <String>[].obs));
  }

  void removeAttribute(int index) {
    attributes.removeAt(index);
  }

  void pickBrandImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['assets/images/products/adidas/'],
    );
    if (result != null) {
      brandImageController.text = result.files.single.path!;
    }
  }

  Future<void> pickAndUploadImageForProduct(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Products/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      images[index].text = downloadUrl;
      images.refresh(); // Cập nhật UI
    }
  }

  Future<void> pickAndUploadImageForThumbnail() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Products/Thumbnail/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      thumbnailController.text = downloadUrl;
      variations.refresh(); // Cập nhật UI
    }
  }

  Future<void> pickAndUploadImageForVariation(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final ref = storage.ref().child('Products/Variations/Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      variations[index].image = downloadUrl;
      variations.refresh(); // Cập nhật UI
    }
  }

  void setProductData(ProductModel product) {
    titleController.text = product.title;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    salePriceController.text = product.salePrice.toString();
    descriptionController.text = product.description!;
    thumbnailController.text = product.thumbnail;
    categoryIdController.text = product.categoryId!;
    selectedProductType.value = product.productType == 'ProductType.single' ? ProductType.single : ProductType.variable;
    isFeatured.value = product.isFeatured!;


    images.clear();
    product.images?.forEach((image) {
      images.add(TextEditingController(text: image));
    });

    attributes.clear();
    product.productAttributes?.forEach((attribute) {
      attributes.add(ProductAttributeModel(name: attribute.name, values: attribute.values?.toList()));
    });

    variations.clear();
    product.productVariations?.forEach((variation) {
      variations.add(ProductVariationModel(
        id: variation.id,
        stock: variation.stock,
        price: variation.price,
        salePrice: variation.salePrice,
        sku: variation.sku,
        image: variation.image,
        description: variation.description,
        attributeValues: variation.attributeValues,
      ));
    });

    brandIdController.text = product.brand!.id;
    brandNameController.text = product.brand!.name;
    brandImageController.text = product.brand!.image;
    brandIsFeatured.value = product.brand!.isFeatured!;
  }

  Map<String, dynamic> formDataToMap() {
    return {
      'title': titleController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'stock': int.tryParse(stockController.text) ?? 0,
      'salePrice': double.tryParse(salePriceController.text) ?? 0.0,
      'description': descriptionController.text,
      'thumbnail': thumbnailController.text,
      'categoryId': categoryIdController.text,
      'productType': selectedProductType.value.toString(),
      'isFeatured': isFeatured.value,
      'images': images.map((controller) => controller.text).toList(),
      'brand': {
        'id': brandIdController.text,
        'name': brandNameController.text,
        'image': brandImageController.text,
        'isFeatured': brandIsFeatured.value,
      },
      'productAttributes': attributes.map((attribute) => {
        'name': attribute.name,
        'values': attribute.values?.toList(), // Convert RxList to List
      }).toList(),
      'productVariations': variations.map((variation) => {
        'id': variation.id,
        'stock': variation.stock,
        'price': variation.price,
        'salePrice': variation.salePrice,
        'sku': variation.sku,
        'image': variation.image,
        'description': variation.description,
        'attributeValues': variation.attributeValues,
      }).toList(),
    };
  }



  Future<void> updateProductData(ProductModel product) async {
   final productId = selectedProductId.value = product.id;
   assignVariationIds();
    if (productId.isEmpty) {
      Get.snackbar('Error', 'No product selected for update');
      return;
    }

    final data =  {
      'Title': titleController.text,
      'Price': double.tryParse(priceController.text) ?? 0.0,
      'Stock': int.tryParse(stockController.text) ?? 0,
      'SalePrice': double.tryParse(salePriceController.text) ?? 0.0,
      'Description': descriptionController.text,
      'Thumbnail': thumbnailController.text,
      'CategoryId': categoryIdController.text,

      'ProductType': selectedProductType.value.toString(),
      'IsFeatured': isFeatured.value,
      'Images': images.map((controller) => controller.text).toList(),
      'Brand': {
        'Id': brandIdController.text,
        'Name': brandNameController.text,
        'Image': brandImageController.text,
        'IsFeatured': brandIsFeatured.value,
      },
      'ProductAttributes': attributes.map((attribute) => {
        'Name': attribute.name,
        'Values': attribute.values?.toList(), // Convert RxList to List
      }).toList(),
      'ProductVariations': variations.map((variation) => {
        'Id': variation.id,
        'Stock': variation.stock,
        'Price': variation.price,
        'SalePrice': variation.salePrice,
        'SKU': variation.sku,
        'Image': variation.image,
        'Description': variation.description,
        'AttributeValues': variation.attributeValues,
      }).toList(),
    };

    try {
      print('Updating product with ID: $productId'); // Log productId
      print('Data: $data'); // Log data
      await repository.updateProduct(productId, data);
      Get.offAll(() => const HomeScreenAdmin());
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      print('Error updating product: $e'); // Log chi tiết lỗi
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  void addVariation() {
    variations.add(ProductVariationModel(
      id: '',
      stock: 1,
      price: 0.0,
      salePrice: 0.0,
      sku: '',
      image: '',
      description: '',
      attributeValues: {
        'Color': color.text,
        'Size': size.text
      },
    ));
  }

  void resetProductData() {
    titleController.clear();
    priceController.clear();
    salePriceController.clear();
    descriptionController.clear();
    thumbnailController.clear();
    categoryIdController.clear();
    brandImageController.clear();
    selectedProductType.value = ProductType.single;
    isFeatured.value = false;
    images.clear();
    attributes.clear();
    variations.clear();
  }

  void removeVariation(int index) {
    variations.removeAt(index);
  }

  Future<String> getNextProductId() async {
    final allProducts = await repository.getAllFeaturedProducts();
    int maxId = 0;

    for (var product in allProducts) {
      int currentId = int.tryParse(product.id) ?? 0;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    int nextId = maxId + 1;
    return nextId.toString().padLeft(3, '0');
  }

  void assignVariationIds() {
    for (int i = 0; i < variations.length; i++) {
      variations[i].id = (i + 1).toString(); // Gán ID từ 1 trở đi
    }
  }
  ///id 001


  Future<List<ProductModel>> getProductsByIds(List<String> productIds) async {
    final productQuery = await FirebaseFirestore.instance
        .collection('Products')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();
    return productQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
  }

  Future<String> generateProductId() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Products').get();
    final productCount = querySnapshot.size;
    return (productCount + 1).toString().padLeft(3, '0');
  }
  Future<void> saveProduct() async {
    assignVariationIds();
    final productId = await generateProductId();

    final brand = BrandModel(
      id: brandIdController.text,
      name: brandNameController.text,
      image: brandImageController.text,
      productsCount: 1,
      isFeatured: brandIsFeatured.value,
    );

    ///get model
    final product = ProductModel(
      id: productId,
      title: titleController.text,
      stock: 1,
      price: double.parse(priceController.text),
      isFeatured: isFeatured.value,
      thumbnail: thumbnailController.text,
      productType: selectedProductType.value.toString(),
      description: descriptionController.text,
      salePrice: double.parse(salePriceController.text),
      categoryId: categoryIdController.text,
      images: images.map((controller) => controller.text).toList(),
      brand: brand,
      productAttributes: attributes,
      productVariations: variations,
    );

    try {
      await repository.addProduct(product);
      Get.snackbar('Success', 'Product added successfully');
      Get.offAll(() => const HomeScreenAdmin());
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }


  Future<void> fetchAllProducts() async {
    try {
      final allProducts = await repository.getAllFeaturedProducts();
      products.assignAll(allProducts);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
    }
  }

  Future<List<ProductModel>> fetchProductByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final products = await repository.fetchProductByQuery(query);

      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;
    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Name');
  }
}
