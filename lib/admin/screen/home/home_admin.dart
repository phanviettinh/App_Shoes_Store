import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/orders/order_admin.dart';
import 'package:sports_shoe_store/admin/signup/signup_admin.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/shimmer.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/features/personalization/controllers/user_controller.dart';
import 'package:sports_shoe_store/features/personalization/screens/profile/profile_screen.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

import 'widget/home_proceeds.dart';
import 'widget/profile_admin.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserController());

    return Scaffold(
      backgroundColor: dark ? TColors.black : TColors.light,
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Home'),
            Spacer(),
            Icon(Iconsax.notification),
            SizedBox(width: TSizes.spaceBtwItems,),
            Icon(Icons.email_outlined),

          ],
        ),
        iconTheme:  IconThemeData(color: dark ? Colors.white : Colors.black), // Đặt màu cho icon menu
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
        DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
        ),
        child: ProfileAdmin(controller: controller),
      ),

            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Loading Images')
                ],
              ),
              onTap: () {
                // Xử lý khi người dùng chọn mục trong menu
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.ship),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Orders')
                ],
              ),
              onTap: () => Get.to(() => const OrderAdmin()),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.box),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Products')
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.flag),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Brands')
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.grid_1),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Categories')
                ],
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Iconsax.document),
                  SizedBox(width: TSizes.spaceBtwItems / 2,),
                  Text('Banners')
                ],
              ),
              onTap: () {
              },
            ),
            const Divider(),

            TextButton(
              onPressed: () {
                // Perform logout action here
                AuthenticationRepository.instance.logoutAdmin();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            )
            // Thêm các mục khác nếu cần
          ],
        ),
      ),
      body: const HomeProceeds(),
    );
  }
}


