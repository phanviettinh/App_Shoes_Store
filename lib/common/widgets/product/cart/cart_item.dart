import 'package:flutter/material.dart';
import 'package:sports_shoe_store/common/widgets/images/rounded_image.dart';
import 'package:sports_shoe_store/common/widgets/text/brand_title_text_with_verified_icon.dart';
import 'package:sports_shoe_store/common/widgets/text/product_title.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
         TRoundedImage(
          imageUrl: TImages.adidasRm1,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: dark ? TColors.darkerGrey : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems,),

        ///title, price, size
        Expanded(child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TBrandTitleWithVerifiedIcon(title: 'Adidas'),
            const Flexible(child: TProductTextTitle(title: 'White Sports Shoe what is doing go to',maxLines: 1,)),
            ///addtributes
            Text.rich(TextSpan(
                children: [
                  TextSpan(text: 'Color',style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(text: 'Green',style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(text: 'Size',style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(text: 'UK 08',style: Theme.of(context).textTheme.bodyLarge),
                ]
            ))
          ],
        ))
      ],
    );
  }
}
