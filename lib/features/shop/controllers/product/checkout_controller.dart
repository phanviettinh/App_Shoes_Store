import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/product/payment_method/payment_method.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/features/shop/models/payment_method_model.dart';
import 'package:sports_shoe_store/utils/constants/enums.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

class CheckoutController extends GetxController{
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'ZaloPay', image: TImages.zaloPay);
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(title: 'Select Payment Method',showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwSections,),
                TPaymentTile(paymentMethod: PaymentMethodModel(name: 'ZaloPay', image: TImages.zaloPay)),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Payment on delivery', image: TImages.paymentDelivery)),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: TImages.applePay)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'VISA', image: TImages.visa)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Master Card', image: TImages.masterCard)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paytm', image: TImages.payTm)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'PayStack', image: TImages.payStack)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                // TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard)),
                // const SizedBox(height: TSizes.spaceBtwItems / 2),
                const SizedBox(height: TSizes.spaceBtwSections,),

              ],
            ),
      ),
    ));
  }


}