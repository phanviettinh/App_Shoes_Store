import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/features/shop/controllers/category_controller.dart';
import 'package:sports_shoe_store/features/shop/models/category_model.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import '../../../common/widgets/appbar/appbar.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({super.key, this.category});

  final CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    if (category != null) {
      controller.setCategoryData(category!);
    } else {
      controller.resetCategoryData();
    }

    return Scaffold(
      appBar: TAppbar(
        title: category == null
            ? const Text('Add Categories')
            : const Text('Update Categories'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickAndUploadImage(),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller.image,
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
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
              controller: controller.name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            TextField(
              controller: controller.parentId,
              decoration: const InputDecoration(labelText: 'Category'),
              onTap: () => controller.showCategoryPickerDialog(context),
              readOnly: true,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Obx(() => Column(
                  children: [
                    const Text('Show UI'),
                    Switch(
                      value: controller.isFeatured.value,
                      onChanged: (value) => controller.isFeatured.value = value,
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final category = this.category;
                  if (category != null) {
                    await controller
                        .updateCategoryData(category); // Hàm update sản phẩm
                  } else {
                    await controller.saveCategory(); // Hàm lưu sản phẩm mới
                  }
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
