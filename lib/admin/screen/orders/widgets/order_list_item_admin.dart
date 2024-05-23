import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/orders/order_admin.dart';
import 'package:sports_shoe_store/admin/screen/orders/widgets/order_detail.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/common/widgets/loaders/animation_loader.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/order/order_detail.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/cloud_helper_function.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TOrderListItemAdmin extends StatelessWidget {
  const TOrderListItemAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    final dark = THelperFunctions.isDarkMode(context);
    return FutureBuilder(
        future: controller.fetAllUserOrders(),
        builder: (_, snapshot) {
          const emptyWidget = TAnimationLoaderWidget(
            text: 'Whoop! No Order Yet!',
            animation: TImages.masterCard,
            showAction: true,
          );

          final response = TCloudHelperFunctions.checkMultiRecordState(
              snapshot: snapshot, nothingFound: emptyWidget);
          if (response != null) return response;

          ///congratulation record found
          final orders = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            itemCount: orders.length,
            itemBuilder: (_, index) {
              final order = orders[index];
              return TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.dark : TColors.light,
                padding: const EdgeInsets.all(TSizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///id orders
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.id,
                            style: Theme.of(context).textTheme.titleMedium)
                      ],
                    ),

                    ///status
                    Text(
                      order.orderStatusText,
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                          color: order.orderStatusText == 'Processing'
                              ? TColors.primaryColor
                              : order.orderStatusText == 'Shipping'
                                  ? Colors.yellow
                                  : order.orderStatusText == 'Received'
                                      ? Colors.green
                                      : Colors.red,
                          fontWeightDelta: 1),
                    ),

                    ///icon
                    IconButton(
                        onPressed: () =>
                            Get.to(() => OrderDetailAdmin(order: order)),
                        icon: const Icon(
                          Iconsax.arrow_right_34,
                          size: TSizes.iconSm,
                        ))
                  ],
                ),
              );
            },
          );
        });
  }
}
