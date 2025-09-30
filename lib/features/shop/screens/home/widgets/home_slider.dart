import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sports_shoe_store/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:sports_shoe_store/common/widgets/images/rounded_image.dart';
import 'package:sports_shoe_store/common/widgets/shimmer/shimmer.dart';
import 'package:sports_shoe_store/features/shop/controllers/banner_controller.dart';
import 'package:sports_shoe_store/features/shop/controllers/home_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';

import '../../../../../common/widgets/loaders/loader.dart';
import '../../../../../utils/helpers/ads_helper.dart';

class TPromoSlider extends StatefulWidget {
  const TPromoSlider({
    super.key,
  });

  @override
  State<TPromoSlider> createState() => _TPromoSliderState();
}

class _TPromoSliderState extends State<TPromoSlider> {

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BannerAd(
        adUnitId: AdsHelper.bannerAdUnitId, size: AdSize.banner, listener:  BannerAdListener(
        onAdLoaded: (ad){
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad,err){
          print('Fail to load banner ads: ${err.message}');
          TLoaders.errorSnackBar(title: 'Fail to load banner ads: ${err.message}');
          ad.dispose();

        }
    ), request:  const AdRequest()

    );
    InterstitialAd.load(adUnitId: AdsHelper.interstitialAdUnitId, request:  const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad){
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){}
      );
      setState(() {
        _interstitialAd = ad;
      });
    }, onAdFailedToLoad: (err){
          print('Fail to load intersititial ads: ${err.message}');

          TLoaders.errorSnackBar(title: 'Fail to load intersititial ads: ${err.message}');

    }));
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(() {
      //loader
      if(controller.isLoading.value) return const TShimmerEffect(width: double.infinity, height: 190);

      //no data found
      if(controller.banners.isEmpty){
        return const Center(child: Text('No Data Found!'),);
      }else{
        return Column(
          children: [
            if(_bannerAd != null)
            Center(
              child: SizedBox(
                width: _bannerAd?.size.width.toDouble(),
                height: _bannerAd?.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
             FloatingActionButton(onPressed: (){
               _interstitialAd?.show();
            },child: Icon(Icons.add),),
            // CarouselSlider(
            //   items: controller.banners
            //       .map((banner) => TRoundedImage(
            //     imageUrl: banner.imageUrl,
            //     isNetworkImage: true,
            //     onPressed: () => Get.toNamed(banner.targetScreen),
            //   ))
            //       .toList(),
            //   options: CarouselOptions(
            //       viewportFraction: 1,
            //       onPageChanged: (index, _) =>
            //           controller.updatePageIndicator(index)),
            // ),
            // const SizedBox(
            //   height: TSizes.spaceBtwItems,
            // ),
            // Center(
            //   child: Obx(() => Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       for (int i = 0; i < controller.banners.length; i++)
            //         TCircularContainer(
            //           width: 20,
            //           height: 4,
            //           backgroundColor:
            //           controller.carousalCurrentIndex.value == i
            //               ? TColors.primaryColor
            //               : TColors.grey,
            //           margin: const EdgeInsets.only(right: 10),
            //         ),
            //     ],
            //   )),
            // )

          ],
        );
      }
    });
  }
}
