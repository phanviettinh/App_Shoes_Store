import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/order/widgets/order_list.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import 'widgets/order_list_item_admin.dart';


class OrderAdmin extends StatelessWidget {
  const OrderAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppbar(
        title: Text('Orders',
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),

        ///orders
        child: TOrderListItemAdmin(),
      ),
    );
  }
}
