import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/screen/orders/order_admin.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

class ProductHomeProceed extends StatelessWidget {
  const ProductHomeProceed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            child: const Column(
              children: [
                Icon(Icons.import_contacts_sharp),
                SizedBox(height: TSizes.spaceBtwItems / 2),
                Text('Orders'),
              ],
            ),
            onTap: () => Get.to(() => const OrderAdmin()),
          ),
          const SizedBox(width: TSizes.spaceBtwSections),
          const Column(
            children: [
              Icon(Icons.import_contacts_sharp),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              Text('Products'),
            ],
          ),
          const SizedBox(width: TSizes.spaceBtwSections),
          const Column(
            children: [
              Icon(Icons.import_contacts_sharp),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              Text('Brands'),
            ],
          ),
          const SizedBox(width: TSizes.spaceBtwSections),
          const Column(
            children: [
              Icon(Icons.import_contacts_sharp),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              Text('Banner'),
            ],
          ),
          const SizedBox(width: TSizes.spaceBtwSections),
          const Column(
            children: [
              Icon(Icons.import_contacts_sharp),
              SizedBox(height: TSizes.spaceBtwItems / 2),
              Text('Categories'),
            ],
          ),
        ],
      ),
    );
  }
}
