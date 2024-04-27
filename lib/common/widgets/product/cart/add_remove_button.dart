import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// remove button
        TCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: dark ? TColors.white :  TColors.black,
          backgroundColor: dark ? TColors.darkerGrey : TColors.light,
        ),

        const SizedBox(width: TSizes.spaceBtwItems,),
        Text('2',style: Theme.of(context).textTheme.titleSmall,),
        const SizedBox(width: TSizes.spaceBtwItems,),

        /// add button
        const TCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color:TColors.white,
          backgroundColor: TColors.primaryColor,
        ),
      ],
    );
  }
}
