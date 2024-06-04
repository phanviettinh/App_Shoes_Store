import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/brands/add_brands_admin.dart';
import 'package:sports_shoe_store/common/widgets/appbar/appbar.dart';
import 'package:sports_shoe_store/common/widgets/brands/brand_card.dart';
import 'package:sports_shoe_store/common/widgets/icon/circular_icon.dart';
import 'package:sports_shoe_store/common/widgets/layouts/grid_layout.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/brands_shimmer.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/features/shop/controllers/brand_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/brands/brand_products.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import 'widgets/brand_product_admin.dart';

class ShowBrandAdmin extends StatelessWidget {
  const ShowBrandAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      appBar:  TAppbar(
          title: const Text('Brands'),
          showBackArrow: true,
          actions: [
            TCircularIcon(icon: Iconsax.add,onPressed: () => Get.to(() =>  const AddBrandsAdmin()))
          ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            ///searchbar
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TextField(
                controller: brandController.searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  brandController.filterBrand(value);
                },
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    ///brands
                    Obx(() {
                      if(brandController.isLoading.value) return const TBrandShimmer();

                      if(brandController.filteredBrands.isEmpty){
                        return Center(child: Text('No Data Found!',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),));
                      }
                      return  TGridLayout(
                          itemCount: brandController.filteredBrands.length,
                          mainAxisExtent: 80,
                          itemBuilder: (_,index){
                            final brand = brandController.filteredBrands[index];
                            return  TBrandCard(
                              showBorder: true,
                              brand: brand,
                              onTap: () => Get.to(() =>  BrandProductAdmin(brand: brand,)),);
                          }
                      );
                    }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}
