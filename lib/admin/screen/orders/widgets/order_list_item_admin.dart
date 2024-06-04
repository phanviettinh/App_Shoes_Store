import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/orders/order_admin.dart';
import 'package:sports_shoe_store/admin/screen/orders/widgets/order_detail.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:sports_shoe_store/common/widgets/loaders/animation_loader.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/features/shop/models/order_model.dart';
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
        future: controller.fetchAllUserOrders(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          ///congratulation record found
          final orders = controller.filteredOrders;

          return Column(
            children: [
              ///searchbar
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search by status',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  controller.filterOrders(value);
                },
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Obx(() => ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                itemCount: orders.length,
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onLongPress: () => _showDeleteConfirmationDialog(context, order, controller),
                    child: TRoundedContainer(
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
                    ),
                  );
                },
              )),
            ],
          );
        });
  }

  void _showDeleteConfirmationDialog(BuildContext context, OrderModel order, OrderController controller) {
    Get.defaultDialog(
      title: 'Delete Order',
      middleText: 'Are you sure you want to delete this order?',
      confirm: ElevatedButton(
        onPressed: () async {
          await controller.deleteOrder(order.userId, order.id);
          Get.back(); // Close the dialog
        },
        child: const Text('Delete'),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(), // Close the dialog
        child: const Text('Cancel'),
      ),
    );
  }
}


