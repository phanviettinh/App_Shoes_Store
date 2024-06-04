import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:sports_shoe_store/admin/screen/products/add_products.dart';
import 'package:sports_shoe_store/admin/screen/products/widgets/product_cart_vertical_admin.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/features/shop/controllers/brand_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/product_controller.dart';
import 'package:sports_shoe_store/features/shop/models/brand_model.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';
import 'package:sports_shoe_store/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:sports_shoe_store/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:sports_shoe_store/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:sports_shoe_store/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import '../../../../features/shop/screens/product_reviews/product_review.dart';
import '../../../../utils/constants/text_strings.dart';

class ProductDetailAdmin extends StatelessWidget {
  const ProductDetailAdmin({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            ///product slider image
            TProductImageSlider(product: product),

            ///product details
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace),
              child: Column(
                children: [

                  ///rating & share button
                  const TRatingAndShare(),

                  ///price, title, stock and brand
                  TProductMetaData(product: product),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ///Attributes
                  TProductAttribute(product: product),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///description
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  ///review
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(
                          title: 'Review(201)', showActionButton: false),
                      IconButton(
                        onPressed: () => Get.to(() => const ProductReview()),
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.deleteProduct(product.id),
                child: const Text('Delete'),
              ),
            ),
            const SizedBox(width: TSizes.defaultSpace),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() =>  AddProducts(product: product,));
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
