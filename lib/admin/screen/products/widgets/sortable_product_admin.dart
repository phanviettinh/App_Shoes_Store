import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/common/widgets/layouts/grid_layout.dart';
import 'package:sports_shoe_store/common/widgets/product/product_carts/product_cart_vertical.dart';
import 'package:sports_shoe_store/features/shop/controllers/all_product_controller.dart';
import 'package:sports_shoe_store/features/shop/models/product_model.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import 'product_cart_vertical_admin.dart';

class TSortableProductAdmin extends StatelessWidget {
  const TSortableProductAdmin({
    super.key, required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductController());
    controller.assignProducts(products);

    return Column(
      children: [
        ///Drop down
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value){
            controller.sortProducts(value!);
          },
          items: ['Name','Higher Price','Lower Price','Sale','Newest','Popularity']
              .map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),

        ///product
        Obx(() => TGridLayout(itemCount: controller.products.length, itemBuilder: (_,index) =>  TProductCartVerticalAdmin(product: controller.products[index],)))
      ],
    );
  }
}
