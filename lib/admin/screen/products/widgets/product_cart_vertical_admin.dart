import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/styles/shadows.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/common/widgets/images/rounded_image.dart';
import 'package:sports_shoe_store/common/widgets/product/product_carts/product_price_text.dart';
import 'package:sports_shoe_store/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:sports_shoe_store/common/widgets/text/product_title.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/product_controller.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';
import 'package:sports_shoe_store/features/shop/screens/product_details/product_details.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import 'product_detail_admin.dart';

class TProductCartVerticalAdmin extends StatelessWidget {
  const TProductCartVerticalAdmin({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(() =>  ProductDetailAdmin(product: product,)),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(TSizes.productImageRadius),
            color: dark ? TColors.darkerGrey : TColors.light),
        child: Column(

            children: [
              ///thumbnail
              TRoundedContainer(
                backgroundColor: dark ? TColors.dark : TColors.light,
                // width: 170,
                // height: 170,
                child: Stack(
                  children: [
                    ///image
                    Center(
                      child: TRoundedImage(
                        imageUrl: product.thumbnail,
                        backgroundColor: TColors.light,
                        applyImageRadius: true,
                        isNetworkImage: true,
                      ),
                    ),

                    if(salePercentage != null)
                    ///sale tag
                      Positioned(
                          top: 12,
                          child: TRoundedContainer(
                            radius: TSizes.sm,
                            backgroundColor: TColors.secondary.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.sm, vertical: TSizes.xs),
                            child: Text(
                              '$salePercentage%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .apply(color: TColors.black),
                            ),
                          )),


                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),

              ///detail
              Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TProductTextTitle(title: product.title, smallSize: true,),
                    const SizedBox(height: TSizes.spaceBtwItems / 2,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TBrandTitleWithVerifiedIcon(title: product.brand!.name,brandTextSizes: TextSizes.large,),
                        // Text('256 products',overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.labelMedium,)
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///price
                  Flexible(child: Column(
                    children: [
                      if(product.productType == ProductType.single.toString() && product.salePrice > 0)
                        Padding(
                            padding: const EdgeInsets.only(left: TSizes.sm),
                            child: Text(product.price.toString(),style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),)
                        ) ,
                      Padding(
                          padding: const EdgeInsets.only(left: TSizes.sm),
                          child: TProductPriceText(price: controller.getProductPrice(product),)
                      )
                    ],
                  )),

                ],
              )
            ],
          ),
        )
   
    );
  }
}


