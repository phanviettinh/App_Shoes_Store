import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/data/repositories/users/user_repository.dart';
import 'package:sports_shoe_store/features/authentication/models/user_model.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';
import 'package:sports_shoe_store/utils/helpers/pricing_caculator.dart';

import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../features/shop/models/order_model.dart';

class OrderDetailAdmin extends StatelessWidget {
  const OrderDetailAdmin({super.key, required this.order});

  final OrderModel order;


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');
    final orderController = Get.put(OrderController());
    final userController = Get.put(UserController());

    return Scaffold(
      appBar: TAppbar(
        title: Text(
          order.orderStatusText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: order.orderStatusText == 'Processing'
                ? TColors.primaryColor
                : order.orderStatusText == 'Shipping'
                ? Colors.yellow
                : order.orderStatusText == 'Received'
                ? Colors.green
                : Colors.red, // Default color if no conditions match
          ),
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Method: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    order.paymentMethod,
                    style: const TextStyle(fontSize: 16,color: Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Shipping Address:',
                style: TextStyle(fontSize: 16),
              ),
              ListTile(
                title: Text(order.address.toString(),style: const TextStyle(fontSize: 14, color: Colors.blueAccent),),
              ),
              const SizedBox(height: 16),
              const Text(
                'Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items.map((item) {
                  return ListTile(
                    leading: item.image != null
                        ? Image.network(item.image!)
                        : const Placeholder(),
                    title: Text(item.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(1)}'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              const Text(
                'Order overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ///Shipping Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Fee',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '+ \$${TPricingCalculator.calculateShippingCost(subTotal, 'US')}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),

              ///Tax Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Fee',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '+ \$${TPricingCalculator.calculateTax(subTotal, 'US')}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),

              ///Order Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Total',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: order.orderStatusText == 'Processing'
            ? ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Submit Order'),
                  content: const Text(
                      'Are you sure you want to Submit this order?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        orderController.shippedOrder(order.userId, totalAmount);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Submit Order'),)
            : order.orderStatusText == 'Cancelled'
            ? null
            : order.orderStatusText == 'Shipped'
            ? null
            : null,
      ),
    );
  }
}
