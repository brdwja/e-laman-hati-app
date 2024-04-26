import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class Intropage extends StatelessWidget {
  const Intropage({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        backgroundColor: Color(0xfff063c8),
        body: (Stack(
          children: [
            Positioned(
              top: -32,
              right: -196,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Color(0xfff172cd),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -250,
              bottom: -16,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xfff172cd),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -220,
              left: -120,
              child: Image.asset('assets/images/cat1.png'),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 128),
                  child: Image.asset('assets/images/lamanhati-putih.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: "Layanan Manajemen "),
                        TextSpan(text: "Kesehatan Hewan", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " Terintegrasi Berbasis Elektronik"),
                      ]
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Image.asset('assets/images/dkpp-putih.png', height: 40,),
            ),
            Positioned(
            bottom: 64,
            right: 16,
            child: ElevatedButton(
              onPressed: () => context.go('/login'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Mulai'),
              ),
            ),
          ),
          ]
        )),
      ),
    );
  }
}

