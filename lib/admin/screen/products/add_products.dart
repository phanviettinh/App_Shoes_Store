import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/features/shop/controllers/all_product_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/product_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import '../../../features/shop/models/product_model.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductController());
    final controller2 = Get.put(ProductController());

    final dark = THelperFunctions.isDarkMode(context);

    if (product != null) {
      controller.setProductData(product!);
    } else {
      controller.resetProductData();
    }
    return Scaffold(
      backgroundColor: dark ? TColors.black : TColors.light,
      appBar: TAppbar(
        title: product == null
            ? const Text('Add Products')
            : const Text('Update Products'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.light,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: controller.priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                        )),
                        const SizedBox(
                          width: TSizes.spaceBtwInoutFields,
                        ),
                        Expanded(
                            child: TextField(
                          controller: controller.salePriceController,
                          decoration:
                              const InputDecoration(labelText: 'Sale Price'),
                          keyboardType: TextInputType.number,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    TextField(
                      controller: controller.descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                controller.pickAndUploadImageForThumbnail(),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: controller.thumbnailController,
                                decoration: const InputDecoration(
                                    labelText: 'Thumbnail URL'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    TextField(
                      controller: controller.categoryIdController,
                      decoration: const InputDecoration(labelText: 'Category'),
                      onTap: () => controller.showCategoryPickerDialog(context),
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///productType
                    Row(
                      children: [
                        const Text('Type: '),
                        const SizedBox(
                          width: TSizes.spaceBtwSections,
                        ),
                        Obx(() => DropdownButton<ProductType>(
                              value: controller.selectedProductType.value,
                              onChanged: (newValue) {
                                controller.selectedProductType.value =
                                    newValue!;
                              },
                              items: ProductType.values.map((type) {
                                return DropdownMenuItem<ProductType>(
                                  value: type,
                                  child: Text(type == ProductType.single
                                      ? 'Single'
                                      : 'Variable'),
                                );
                              }).toList(),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            ///image array
            Container(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.light,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    Obx(() => Column(
                          children: [
                            ...List.generate(controller.images.length, (index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: controller.images[index],
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Product ${index + 1} URL'),
                                          onTap: () => controller
                                              .pickAndUploadImageForProduct(
                                                  index),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () =>
                                            controller.removeImage(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                ],
                              );
                            }),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: controller.addImage,
                                child: const Text('Image products'),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///isFeatured
            Container(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.light,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    Obx(() => Row(
                          children: [
                            const Text('Show UI User: '),
                            const SizedBox(width: TSizes.spaceBtwSections),
                            Switch(
                              value: controller.isFeatured.value,
                              onChanged: (value) =>
                                  controller.isFeatured.value = value,
                            ),
                          ],
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextField(
                      controller: controller.brandImageController,
                      decoration:
                          const InputDecoration(labelText: 'Brand Image'),
                      onTap: () => controller.showImagePickerDialog(context),
                      readOnly: true,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///attribute
            Container(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.light,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    Obx(() => Column(
                          children: List.generate(controller.attributes.length,
                              (index) {
                            final attribute = controller.attributes[index];
                            return Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Attribute Name ${index + 1}'),
                                  onChanged: (value) {
                                    attribute.name = value;
                                  },
                                ),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                Column(
                                  children: [
                                    ...List.generate(attribute.values!.length,
                                        (valueIndex) {
                                      final textController =
                                          TextEditingController(
                                              text: attribute
                                                  .values?[valueIndex]);
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: textController,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Values ${valueIndex + 1}'),
                                              onChanged: (newValue) {
                                                attribute.values?[valueIndex] =
                                                    newValue;
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => controller
                                                .removeValue(index, valueIndex),
                                          ),
                                        ],
                                      );
                                    }),
                                    const SizedBox(
                                        height: TSizes.spaceBtwItems),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            controller.addValue(index),
                                        child: const Text('Add values'),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: TSizes.spaceBtwItems),
                                  ],
                                ),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        controller.removeAttribute(index),
                                    child: const Text('Remove'),
                                  ),
                                ),
                                const SizedBox(height: TSizes.spaceBtwItems),
                              ],
                            );
                          }),
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: controller.addAttribute,
                        child: const Text('Add attributes'),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            ///variation
            Container(
              decoration: BoxDecoration(
                color: dark ? TColors.black : TColors.light,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    Obx(() => Column(
                          children: [
                            ...List.generate(controller.variations.length,
                                (index) {
                              final variation = controller.variations[index];
                              return Column(
                                children: [
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  GestureDetector(
                                    onTap: () => controller
                                        .pickAndUploadImageForVariation(index),
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: variation.image),
                                        decoration: InputDecoration(
                                            labelText:
                                                'Variation Image ${index + 1}'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText:
                                            'Variation Price ${index + 1}'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      variation.price = double.parse(value);
                                    },
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText:
                                            'Variation Sale Price ${index + 1}'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      variation.salePrice = double.parse(value);
                                    },
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Color ${index + 1}'),
                                    onChanged: (value) {
                                      variation.attributeValues['Color'] =
                                          value;
                                    },
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Size ${index + 1}'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      variation.attributeValues['Size'] = value;
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () =>
                                        controller.removeVariation(index),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: controller.addVariation,
                                child: const Text('Add variations'),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final product = this.product;
          if (product != null) {
            await controller.updateProductData(product); // Hàm update sản phẩm
          } else {
            await AllProductController.instance
                .saveProduct(); // Hàm lưu sản phẩm mới
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
