import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/common/widgets/images/circular_image.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/shimmer.dart';
import 'package:sports_shoe_store/features/personalization/controllers/user_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/image_strings.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: Obx(
        () {
          final networkImage = controller.user.value.profilePicture;
          final image = networkImage.isNotEmpty ? networkImage : TImages.user;
          return controller.imageUploading.value
              ? const TShimmerEffect(
                  width: 50,
                  height: 50,
                  radius: 50,
                )
              : TCircularImage(
                  image: image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  isNetworkImage: networkImage.isNotEmpty,
                );
        },
      ),
      title: Text(
        controller.user.value.fullName,
        style: const TextStyle(fontSize: 16, color: TColors.white),
      ),
      subtitle: Text(
        controller.user.value.email,
        style: const TextStyle(fontSize: 12, color: TColors.white),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: TColors.white,
        ),
      ),
    );
  }
}
