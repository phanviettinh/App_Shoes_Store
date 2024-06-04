import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/screen/categories/widgets/sub_category_admin.dart';
import 'package:sports_shoe_store/common/widgets/image_text_widget/vertical_image.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/category_shimmer.dart';
import 'package:sports_shoe_store/features/shop/controllers/category_controller.dart';
import 'package:sports_shoe_store/features/shop/screens/sub_categories/sub_categories.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';

class THomeCategoryAdmin extends StatelessWidget {
  const THomeCategoryAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    return Obx(() {
      if (categoryController.isLoading.value) return const TCategoryShimmer();

      if (categoryController.filteredCategories.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!',
            style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }

      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.filteredCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = categoryController.filteredCategories[index];
            return TVerticalImageText(
              image: category.image,
              title: category.name,
              onTap: () => Get.to(() => SubCategoryAdmin(category: category)),
            );
          },
        ),
      );
    });
  }
}
