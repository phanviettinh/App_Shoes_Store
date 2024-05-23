import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sports_shoe_store/admin/screen/orders/order_admin.dart';
import 'package:sports_shoe_store/common/widgets/text/section_heading.dart';
import 'package:sports_shoe_store/features/shop/controllers/product/order_controller.dart';
import 'package:sports_shoe_store/utils/constants/colors.dart';
import 'package:sports_shoe_store/utils/constants/sizes.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class HomeProceeds extends StatelessWidget {
  const HomeProceeds({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final orderController = Get.put(OrderController());

    // Gọi hàm fetchReceivedOrders để lấy dữ liệu
    orderController.fetchReceivedOrders();

    return SingleChildScrollView(
      child: Column(
        children: [
          /// Header
          Container(
            decoration: BoxDecoration(
              color: dark ? TColors.black : TColors.light,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwSections),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: dark ? TColors.black : TColors.light,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    width: 300,
                    height: 180,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Row(
                          children: [
                            Text(
                              '${orderController.receivedOrdersCount.value} Orders',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwSections * 4),
                            const Text(
                              'profit',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems / 1.5),
                            const Icon(Iconsax.eye_slash),
                          ],
                        )),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Obx(() => Row(
                          children: [
                            Text(
                              '${orderController.totalProfit.value.toStringAsFixed(1)} \$',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwSections * 3.5),
                            const Text(
                              '*****',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const Divider(),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        const Row(
                          children: [
                            Icon(Iconsax.receipt),
                            SizedBox(width: TSizes.spaceBtwItems / 4),
                            Text(
                              '0 returns',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Các sản phẩm
                   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: const Column(
                            children: [
                              Icon(Icons.import_contacts_sharp),
                              SizedBox(height: TSizes.spaceBtwItems / 2),
                              Text('Orders'),
                            ],
                          ),
                          onTap: () => Get.to(() => const OrderAdmin()),
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        const Column(
                          children: [
                            Icon(Icons.import_contacts_sharp),
                            SizedBox(height: TSizes.spaceBtwItems / 2),
                            Text('Products'),
                          ],
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        const Column(
                          children: [
                            Icon(Icons.import_contacts_sharp),
                            SizedBox(height: TSizes.spaceBtwItems / 2),
                            Text('Brands'),
                          ],
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        const Column(
                          children: [
                            Icon(Icons.import_contacts_sharp),
                            SizedBox(height: TSizes.spaceBtwItems / 2),
                            Text('Banner'),
                          ],
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        const Column(
                          children: [
                            Icon(Icons.import_contacts_sharp),
                            SizedBox(height: TSizes.spaceBtwItems / 2),
                            Text('Categories'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Body
          Container(
            decoration: BoxDecoration(
              color: dark ? TColors.black : TColors.light,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(
                        title: 'Revenue',
                        showActionButton: false,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 20, // Đặt maxY thành một giá trị hợp lệ, ví dụ: 20
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: 8,
                              color: Colors.blue,
                            ),
                          ],
                          showingTooltipIndicators: [5],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: 10,
                              color: Colors.blue,
                            ),
                          ],
                          showingTooltipIndicators: [5],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: 14,
                              color: Colors.blue,
                            ),
                          ],
                          showingTooltipIndicators: [5],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: 15,
                              color: Colors.blue,
                            ),
                          ],
                          showingTooltipIndicators: [5],
                        ),
                        BarChartGroupData(
                          x: 4,
                          barRods: [
                            BarChartRodData(
                              toY: 13,
                              color: Colors.blue,
                            ),
                          ],
                          showingTooltipIndicators: [5],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    );
  }
}
