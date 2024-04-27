import 'package:flutter/material.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return  Column(
      children: [
        TSectionHeading(title: 'Payment Method',buttonTitle: 'Change',onPressed: (){},),
        const SizedBox(height: TSizes.spaceBtwItems / 2,),
        Row(
          children: [
            TRoundedContainer(
              width: 60,
              height: 60,
              backgroundColor: dark ? TColors.light : TColors.white,
              padding: const EdgeInsets.all(TSizes.sm),
              child: const Image(image: AssetImage(TImages.payPal),fit: BoxFit.contain,),
            ),
            const SizedBox(width: TSizes.spaceBtwItems / 2,),
            Text('Paypal',style: Theme.of(context).textTheme.bodyLarge,)

          ],
        )
      ],
    ) ;
  }
}
