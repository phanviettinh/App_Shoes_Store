import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/cart_menu_icon.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/shimmer.dart';
import 'package:sports_shoe_store/features/personalization/controllers/user_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';

class THomeAppbar extends StatelessWidget {
  const THomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppbar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: TColors.grey),
          ),
           Obx(() {
             if(controller.profileLoading.value){
               return const TShimmerEffect(width: 80, height: 25);
             }else{
               return Text(
                 controller.user.value.fullName,
                 style: const TextStyle(color: TColors.grey,fontSize: 18),
               );
             }

           } )
        ],
      ),
      actions: [
        TCartCounterIcon(
          // onPressed: () {},
          iconColor: TColors.white,
        )
      ],
    );
  }
}
