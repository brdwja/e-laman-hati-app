import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xffff6392)
        ),
        backgroundColor: Colors.white,
        title: const Text('Berita Utama'),
        titleTextStyle: const TextStyle(
          color: Color(0xff525f7f),
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
      body: const Text('Berita Utama'),
      endDrawer: const NavDrawer(),
    );
  }
}