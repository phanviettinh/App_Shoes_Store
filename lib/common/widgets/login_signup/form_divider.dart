import 'package:flutter/material.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import '../../../main.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key, required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey,thickness: 0.5,indent: 60,endIndent: 5,)),
        Text(dividerText,style: Theme.of(context).textTheme.labelMedium,),
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey,thickness: 0.5,indent: 5,endIndent: 60,)),
      ],
    );
  }
}
