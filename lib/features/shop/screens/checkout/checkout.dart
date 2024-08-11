import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/cart_item.dart';
import 'package:sports_shoe_store/common/widgets/product/cart/coupon_widget.dart';
import 'package:sports_shoe_store/common/widgets/succes_screen/succes_screen.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/cart_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/cart/widgets/cart_item.dart';
import 'package:sports_shoe_store/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:sports_shoe_store/navigation_menu.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';
import 'package:sports_shoe_store/utils/helpers/pricing_caculator.dart';

import '../../../../data/repositories/payment/payment.dart';
import '../../../../utils/payment/theme_data.dart';
import '../../controllers/product/checkout_controller.dart';
import 'widgets/billing_address_section.dart';
import 'widgets/billing_payment_section.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const EventChannel eventChannel =
  EventChannel('flutter.native/eventPayOrder');
  static const MethodChannel platform =
  MethodChannel('flutter.native/channelPayOrder');
  String zpTransToken = "";
  String payResult = "";
  bool showResult = false;

  final CheckoutController _checkoutController = Get.put(CheckoutController());


  Future<void> _createOrderAndPay(String amount) async {
    int parsedAmount = (double.parse(amount) * 22222).toInt(); // Update the amount conversion
    if (parsedAmount < 1000 || parsedAmount > 100000000) {
      setState(() {
        zpTransToken = "Invalid Amount";
      });
      return;
    }

    // Hiển thị vòng quay loading
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Tạo đơn hàng
    var result = await createOrder(parsedAmount);
    Navigator.pop(context); // Tắt vòng quay loading

    if (result != null) {
      zpTransToken = result.zptranstoken;
      setState(() {
        zpTransToken = result.zptranstoken;
        showResult = true;
      });

      // Tiến hành thanh toán
      String response = "";
      try {
        final String result =
        await platform.invokeMethod('payOrder', {"zptoken": zpTransToken});
        response = result;
        print("payOrder Result: '$result'.");
        if (response == "Payment Success") {
          _processOrder(); // Call order processing method on successful payment
        }
      } on PlatformException catch (e) {
        print("Failed to Invoke: '${e.message}'.");
        response = "Thanh toán thất bại";
      }
      print(response);
      setState(() {
        payResult = response;
      });
    }
  }

  void _processOrder() {
    final orderController = Get.put(OrderController());
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');

    orderController.processOrder(totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');

    return Scaffold(
      appBar: TAppbar(
        title: Text('Order Review',
            style: TextStyle(
                fontSize: 20, color: dark ? TColors.white : TColors.dark)),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///item in cart
              const TCartItems(
                showAddRemoveButtons: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///coupon TextField
              const TCouponCode(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///billing section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    ///pricing
                    TBillingAmountSection(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///divider
                    Divider(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///payment methods
                    TBillingPaymentSection(),
                    SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///address
                    TBillingAddressSection()
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      ///checkout buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subTotal > 0
              ? () {
            if (_checkoutController.selectedPaymentMethod.value.name == 'ZaloPay') {
              _createOrderAndPay(totalAmount.toString());
            } else {
              _processOrder();
            }
          }
              : () => TLoaders.warningSnackBar(
              title: 'Empty Cart',
              message: 'Add items in the cart in order to proceed'),
          child: Text('Checkout \$$totalAmount'),
        ),
      ),
    );
  }}