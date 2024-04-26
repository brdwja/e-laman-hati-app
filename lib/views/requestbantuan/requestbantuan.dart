import 'package:flutter/material.dart';

import '../../widgets/nav_drawer.dart';

import './tabs/tambah.dart';
import './tabs/riwayat.dart';

class RequestBantuan extends StatelessWidget {
  const RequestBantuan({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Color(0xffff6392)
          ),
          backgroundColor: Colors.white,
          title: const Text('Minta Bantuan'),
          titleTextStyle: const TextStyle(
            color: Color(0xff525f7f),
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.history),
                child: Text('Riwayat'),
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
              RiwayatBantuan(),
              TambahBantuan(),
            ],
          ),
        endDrawer: const NavDrawer(),
      ),
    );
  }
}