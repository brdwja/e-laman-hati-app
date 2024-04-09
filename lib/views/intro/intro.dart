import 'package:flutter/material.dart';

class Intropage extends StatelessWidget {
  const Intropage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(child: Text('Intro')),
    );
  }
}