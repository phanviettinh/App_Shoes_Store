import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/bindings/genaral_bindings.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/theme/theme.dart';

import 'routes/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBinding(),
      getPages: AppRoutes.pages,
      home: const Scaffold(backgroundColor: TColors.primaryColor,body: Center(child: CircularProgressIndicator(color: TColors.white,),),),
      debugShowCheckedModeBanner: false,
    );
  }
}
