import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sports_shoe_store/admin/signup/signup_admin.dart';
import 'package:sports_shoe_store/data/repositories/authentication/authentication_repository.dart';
import 'package:sports_shoe_store/utils/constants/text_strings.dart';
import 'package:sports_shoe_store/utils/helpers/helper_funtions.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        iconTheme:  IconThemeData(color: dark ? Colors.white : Colors.black), // Đặt màu cho icon menu
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Xử lý khi người dùng chọn mục trong menu
              },
            ),
            ListTile(
              title: const Text('Item 2'),
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
      body: const Center(
        child: Text('Admin Home Screen'),
      ),
    );
  }
}
