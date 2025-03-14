// custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.blue, // Customize as needed
    );
  }

  // This sets the height of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
