import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TOrderListItem extends StatelessWidget {
  const TOrderListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_,__) => const SizedBox(height: TSizes.spaceBtwItems,),
        itemCount: 5,
        itemBuilder: (_,index) => TRoundedContainer(
          showBorder: true,
          backgroundColor: dark ? TColors.dark : TColors.light,
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///row1
              Row(
                children: [
                  /// icon
                  const Icon(Iconsax.ship),
                  const SizedBox(width: TSizes.spaceBtwItems / 2,),

                  /// status & date
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Processing',style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primaryColor,fontWeightDelta: 1),),
                      const Text('07 Nov 2024',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),),

                  ///icon
                  IconButton(onPressed: (){}, icon: const Icon(Iconsax.arrow_right_34,size: TSizes.iconSm,))
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems,),

              ///row2
              Row(
                children: [
                  Expanded(child: Row(
                    children: [
                      /// icon
                      const Icon(Iconsax.tag),
                      const SizedBox(width: TSizes.spaceBtwItems / 2,),

                      /// status & date
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order',style: Theme.of(context).textTheme.labelMedium),
                          Text('[#2523d]',style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),),

                    ],
                  ),),
                  ///row3
                  Expanded(child: Row(
                    children: [
                      /// icon
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: TSizes.spaceBtwItems / 2,),

                      /// status & date
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shipping Date',style: Theme.of(context).textTheme.labelMedium),
                          Text('09 Nov 2024',style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),),

                    ],
                  ),)
                ],
              ),


            ],
          ),
        ),
    );
  }
}
