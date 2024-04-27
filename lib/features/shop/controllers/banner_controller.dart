import 'package:get/get.dart';
import 'package:sports_shoe_store/common/widgets/loaders/loader.dart';
import 'package:sports_shoe_store/data/repositories/banners/banner_repository.dart';
import 'package:sports_shoe_store/features/shop/models/banner_model.dart';

class BannerController extends GetxController{

  ///variables
  final carousalCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;


  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  ///update page navigational dots
  void updatePageIndicator(index){
    carousalCurrentIndex.value = index;
  }

  ///fetch controller
  Future<void> fetchBanners() async{
    try{
      //show loader
      isLoading.value = true;

      //fetch banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      //assign banners
      this.banners.assignAll(banners);

    }catch(e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }finally{
      //remove loader
      isLoading.value = false;
    }
  }

}
