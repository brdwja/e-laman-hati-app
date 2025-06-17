import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/nav_drawer.dart';

import './tabs/tambah.dart';
import 'tabs/daftar.dart';

class HewanPeliharaan extends StatelessWidget {
  const HewanPeliharaan({super.key});
  @override
  Widget build(BuildContext context) {
    final String? role = GetStorage().read('USER_ROLE');
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xffff6392)),
          backgroundColor: Colors.white,
          title: role == "peternak"
              ? Text('Hewan ternak')
              : Text('Hewan Peliharaan'),
          titleTextStyle: const TextStyle(
            color: Color(0xff525f7f),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
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
        endDrawer: const NavDrawer(),
        body: const SafeArea(
          child: TabBarView(
            children: [
              DaftarHewanPeliharaan(),
              TambahHewanPeliharaan(),
            ],
          ),
        ),
      ),
    );
  }
}
