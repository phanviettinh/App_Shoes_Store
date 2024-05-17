import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/login/widget/login_form_admin.dart';
import 'package:sports_shoe_store/common/styles/spacing_styles.dart';
import 'package:sports_shoe_store/common/widgets/login_signup/form_divider.dart';
import 'package:sports_shoe_store/features/authentication/screens/login/login.dart';
import 'package:sports_shoe_store/features/authentication/screens/login/widgets/login_form.dart';
import 'package:sports_shoe_store/features/authentication/screens/login/widgets/login_header.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class LoginAdminScreen extends StatelessWidget {
  const LoginAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///logo and subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(onTap: () => Get.offAll(() => const LoginScreen()),child: const Icon(Iconsax.user,size: 30,),)
                    ],
                  ),
                  Image(
                    height: 150,

                    image: AssetImage(
                        dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                  ),
                  Text(
                    'WelCome Administrator',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: TSizes.sm,
                  ),

                ],
              ),

              ///form
              const TLoginFormAdmin(),


            ],
          ),
        ),
      ),
    );
  }
}
