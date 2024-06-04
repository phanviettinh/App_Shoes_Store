import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/categories/add_category.dart';
import 'package:sports_shoe_store/admin/screen/categories/home_category_admin.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading2.dart';
import 'package:sports_shoe_store/features/shop/controllers/category_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/home/widgets/home_category.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import '../../../common/widgets/appbar/appbar.dart';

class ShowCategory extends StatelessWidget {
  const ShowCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return  Scaffold(
      appBar: TAppbar(
        title: const Text('Categories'),
        showBackArrow: true,
          actions: [
            TCircularIcon(icon: Iconsax.add,onPressed: () => Get.to(() =>  const AddCategory()))
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            ///searchbar
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                controller.filterCategory(value);
              },
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            const SingleChildScrollView(
              child: ///categories
              Padding(
                padding: EdgeInsets.only(left: TSizes.defaultSpace),
                child: Column(
                  children: [
                    ///heading
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///categories
                    THomeCategoryAdmin()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
