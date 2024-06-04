import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/screen/categories/add_category.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/product/product_carts/product_cart_horizontal.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/horizontal_product_shimmer.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/features/shop/controllers/category_controller.dart';
import 'package:sports_shoe_store/features/shop/models/category_model.dart';
import 'package:sports_shoe_store/features/shop/screens/all_product/all_product.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/cloud_helper_function.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class SubCategoryAdmin extends StatelessWidget {
  const SubCategoryAdmin({super.key, required this.category});

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppbar(
        title: Text(category.name,
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [


                    ///sub_categories
                    FutureBuilder(future: controller.getSubCategories(category.id), builder: (context, snapshot){

                      ///no record
                      const loader = THorizontalProductShimmer();
                      final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                      if(widget != null) return widget;

                      ///record found
                      final subCategories = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: subCategories.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index){

                          final subCategory = subCategories[index];

                          return FutureBuilder(future: controller.getCategoryProducts(categoryId: subCategory.id), builder: (context, snapshot){

                            ///no record
                            final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                            if(widget != null) return widget;

                            ///record found
                            final products = snapshot.data!;

                            return Column(
                              children: [
                                ///heading
                                TSectionHeading(
                                    title: subCategory.name,
                                    onPressed: () => Get.to(
                                            () => AllProductScreen(
                                          title: subCategory.name,
                                          futureMethod: controller.getCategoryProducts(categoryId: subCategory.id, limit: -1),))
                                ),
                                const SizedBox(height: TSizes.spaceBtwItems / 2,),

                                ///categories
                                SizedBox(
                                  height: 120,
                                  child:  ListView.separated(
                                      itemCount: products.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context,index) => const SizedBox(width: TSizes.spaceBtwItems,),
                                      itemBuilder: (context,index) =>  TProductCartHorizontal(product: products[index])
                                  ),
                                )

                              ],
                            );
                          });
                        },

                      );

                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.deleteCategory(category.id),
                child: const Text('Delete'),
              ),
            ),
            const SizedBox(width: TSizes.defaultSpace),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() =>  AddCategory(category: category,));
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
