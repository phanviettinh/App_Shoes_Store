import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/common/widgets/succes_screen/succes_screen.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/data/repositories/orders/orders_repository.dart';
import 'package:sports_shoe_store/features/personalization/models/address_model.dart';
import 'package:sports_shoe_store/features/personalization/screens/settings/setting_screen.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/features/shop/models/order_model.dart';
import 'package:sports_shoe_store/features/shop/screens/order/widgets/order_list.dart';
import 'package:sports_shoe_store/navigation_menu.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';
import 'package:sports_shoe_store/utils/helpers/pricing_caculator.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({Key? key, required this.order}) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');
    final orderController = Get.put(OrderController());

    return Scaffold(
      appBar: TAppbar(
        title: Text(
          order.orderStatusText,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: order.orderStatusText == 'Processing'
          ? TColors.primaryColor
              : Colors.red),
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(order.orderStatusText == 'Processing')
              Text(
                'Delivery Date: ${order.formattedDeliveryDate.isNotEmpty ? order.formattedOrderDate : "N/A"} - ${order.formattedDeliveryDate} ',
                style: const TextStyle(fontSize: 14),
              ),
              if(order.orderStatusText == 'Processing')
                const SizedBox(height: 8),
              Text(
                'Payment Method: ${order.paymentMethod}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Shipping Address:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text(order.address.toString()),
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
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),

              ),
              const SizedBox(height: 8),

                  // ///subTotal
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('SubTotal',style: Theme.of(context).textTheme.bodyMedium,),
                  //     Text('\$$subTotal',style: Theme.of(context).textTheme.bodyMedium,),
                  //   ],
                  // ),

                  ///Shipping Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping Fee',style: Theme.of(context).textTheme.bodyMedium,),
                      Text('+ \$${TPricingCalculator.calculateShippingCost(subTotal, 'US')}',style: Theme.of(context).textTheme.labelLarge,),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2,),

                  ///Tax Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax Fee',style: Theme.of(context).textTheme.bodyMedium,),
                      Text('+ \$${TPricingCalculator.calculateTax(subTotal, 'US')}',style: Theme.of(context).textTheme.labelLarge,),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2,),

                  ///Order Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Total',style: Theme.of(context).textTheme.bodyMedium,),
                      Text('\$${order.totalAmount.toStringAsFixed(1)}',style: Theme.of(context).textTheme.titleMedium,),
                    ],
                  ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: order.orderStatusText == 'Processing' ? ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Cancel Order'),
                  content:
                      const Text('Are you sure you want to cancel this order?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        orderController.cancelledOrder(totalAmount);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Cancel Order'),
        ) : ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('No Action'),
                  content:
                  const Text('Your order has been cancelled'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(primary: Colors.grey),
          child: const Text('Cancelled Order'),
        ),
      ),
    );
  }
}
