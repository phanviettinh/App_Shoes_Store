import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/common/widgets/images/rounded_image.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/add_remove_button.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/cart_item.dart';
import 'package:sports_shoe_store/common/widgets/product/product_carts/product_price_text.dart';
import 'package:sports_shoe_store/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:sports_shoe_store/common/widgets/text/product_title.dart';
import 'package:sports_shoe_store/features/shop/screens/checkout/checkout.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import 'widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppbar(
          title: Text('Cart', style: TextStyle(fontSize: 20, color: dark ? TColors.white : TColors.dark)),
          showBackArrow: true,
      ),
      body:  const Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),

          ///item in cart
          child: TCartItems(showAddRemoveButtons: true,),
        ),

      ///checkout buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(onPressed: () => Get.to(() => const CheckoutScreen()),child: const Text('Checkout \$256.0'),),
      ),
    );
  }
}



