import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/login/forget_password/forget_password_admin.dart';
import 'package:sports_shoe_store/admin/signup/signup_admin.dart';
import 'package:sports_shoe_store/features/authentication/controllers/login/login_controller.dart';
import 'package:sports_shoe_store/features/authentication/screens/password/forget_password.dart';
import 'package:sports_shoe_store/features/authentication/screens/signup/signup.dart';
import 'package:sports_shoe_store/navigation_menu.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';
import 'package:sports_shoe_store/utils/validators/validation.dart';

class TLoginFormAdmin extends StatelessWidget {
  const TLoginFormAdmin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              ///email
              TextFormField(
                controller: controller.email,
                validator: (value) => TValidator.validateEmail(value) ,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInoutFields,
              ),

              ///password
              Obx(() => TextFormField(
                controller: controller.password,
                validator: (value) => TValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                expands: false,
                decoration:  InputDecoration(
                    labelText: TTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon:  Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                    )
                ),
              )),
              const SizedBox(
                height: TSizes.spaceBtwInoutFields / 2,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Remember password
                  Row(
                    children: [
                      Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                      )),
                      const Text(TTexts.rememberMe)
                    ],
                  ),

                  ///forget password
                  TextButton(
                      onPressed: () => Get.to(() => const ForgetPasswordAdmin()),
                      child: const Text(TTexts.forgetPassword)),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.emailAndPasswordSignInAdmin(),
                    child: const Text(TTexts.signIn)),
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              ///create account
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreenAdmin()),
                    child: const Text(TTexts.createAccount)),
              ),
            ],
          ),
        ));
  }
}
