import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/login/login_admin_screen.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Admin Verification'),
                      content: const Text('Are you an admin?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Get.offAll(() => const LoginAdminScreen());
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Iconsax.user_cirlce_add, size: 30),
            )
          ],
        ),
        Image(
          height: 150,
          image: AssetImage(
              dark ? TImages.lightAppLogo : TImages.darkAppLogo),
        ),
        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: TSizes.sm,
        ),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
