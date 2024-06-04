import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/brands/add_brands_admin.dart';
import 'package:sports_shoe_store/admin/screen/products/widgets/sortable_product_admin.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/brands/brand_card.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/common/widgets/product/sortable/sortable_product.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:sports_shoe_store/features/shop/controllers/brand_controller.dart';
import 'package:sports_shoe_store/features/shop/models/brand_model.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/cloud_helper_function.dart';

class BrandProductAdmin extends StatelessWidget {
  const BrandProductAdmin({super.key, required this.brand});

  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    return  Scaffold(
      appBar:  TAppbar(title: Text(brand.name),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///brands detail
              TBrandCard(showBorder: true, brand: brand,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              FutureBuilder(future: controller.getBrandProducts(brandId: brand.id), builder: (context, snapshot){

                ///handle loader, no record, or error message
                const loader = TVerticalProductShimmer();
                final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                if(widget != null) return widget;

                ///record found!
                final brandProducts = snapshot.data!;
                return  TSortableProductAdmin(products: brandProducts);
              })
            ],
          ),
        ),
      ),
    );
  }
}
