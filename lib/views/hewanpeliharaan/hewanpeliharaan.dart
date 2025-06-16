import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

import './tabs/tambah.dart';
import 'tabs/daftar.dart';

class HewanPeliharaan extends StatelessWidget {
  const HewanPeliharaan({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xffff6392)),
          backgroundColor: Colors.white,
          title: const Text('Hewan Peliharaan'),
          titleTextStyle: const TextStyle(
              color: Color(0xff525f7f),
              fontSize: 16,
              fontWeight: FontWeight.w600),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.pets),
                child: Text('Daftar'),
              ),
              Tab(
                icon: Icon(Icons.diamond),
                child: Text('Tambah'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            DaftarHewanPeliharaan(),
            TambahHewanPeliharaan(),
          ],
        ),
        endDrawer: const NavDrawer(),
      ),
    );
  }
}
