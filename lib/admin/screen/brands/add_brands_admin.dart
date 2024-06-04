import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/features/shop/controllers/brand_controller.dart';
import 'package:sports_shoe_store/features/shop/models/brand_model.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

class AddBrandsAdmin extends StatelessWidget {
  const AddBrandsAdmin({super.key, this.brand});

  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());

    if (brand != null) {
      controller.setBrandData(brand!);
    } else {
      controller.resetBrandData();
    }

    return Scaffold(
      appBar: TAppbar(
        title: brand == null
            ? const Text('Add Brands')
            : const Text('Update Brands'),
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
                      final brand = this.brand;
                      if (brand != null) {
                        await controller
                            .updateBrandData(brand); // Hàm update sản phẩm
                      } else {
                        await controller.saveBrand(); // Hàm lưu sản phẩm mới
                      }
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          )
    );
  }
}
