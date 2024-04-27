import 'package:flutter/material.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/add_remove_button.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/cart_item.dart';
import 'package:sports_shoe_store/common/widgets/product/product_carts/product_price_text.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,  this.showAddRemoveButtons = false,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections,),
      itemCount: 2,
      shrinkWrap: true,
      itemBuilder: (_, index) =>  Column(
        children: [

          ///title, price, size
          const TCartItem(),
          if(showAddRemoveButtons)  const SizedBox(height: TSizes.spaceBtwItems,),

          if(showAddRemoveButtons)  const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ///extra space
                  SizedBox(width: 70,),

                  ///add remove button
                  TProductQuantityWithAddRemoveButton(),
                ],
              ),

              ///price
              TProductPriceText(price: '256')

            ],
          )
        ],
      ),
    );
  }
}
