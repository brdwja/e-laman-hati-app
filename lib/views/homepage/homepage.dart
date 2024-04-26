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
        title: const Text('Utama'),
        titleTextStyle: const TextStyle(
          color: Color(0xff525f7f),
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card.filled(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xfff063c8)
                      ),
                      child: SizedBox(
                        height: 160,
                        child: Stack(
                          children: [
                            Positioned(
                              top: -280,
                              right: -150,
                              child: Container(
                                width: 400,
                                height: 400,
                                decoration: const BoxDecoration(
                                  color: Color(0xfff172cd),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Image.asset('assets/images/dkpp-putih.png', height: 40,),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Selamat\nDatang,", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, height: 1, color: Colors.white),),
                                  SizedBox(height: 8,),
                                  Text("Wargi Bandung!", style: TextStyle(fontSize: 32, height: 1, color: Colors.white),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rumah Anda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff32325d))),
                          const Text('Kecamatan, Kelurahan', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffff6392),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Dokter Sekitar'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Card.filled(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                elevation: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Kucing Tercatat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff32325d))),
                          const Text('Steril: 40/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                          const Text('Vaksin: 20/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffb3b1b2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Column(
                          children: [
                            Text('1000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Ekor', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Card.filled(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                elevation: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Anjing Tercatat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff32325d))),
                          const Text('Steril: 40/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                          const Text('Vaksin: 20/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffb3b1b2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Column(
                          children: [
                            Text('1000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Ekor', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Card.filled(
                clipBehavior: Clip.hardEdge,
                color: Colors.white,
                elevation: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Hewan Lainnya Tercatat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff32325d))),
                          const Text('Steril: 40/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                          const Text('Vaksin: 20/1000', style: TextStyle(fontSize: 16, color: Color(0xff32325d))),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffb3b1b2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Column(
                          children: [
                            Text('1000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Ekor', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      endDrawer: const NavDrawer(),
    );
  }
}