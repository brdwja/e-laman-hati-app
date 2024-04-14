import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../api/authentication.dart';

class Logoutpage extends StatelessWidget {
  const Logoutpage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      try {
        await Authentication().logout();
        if (!context.mounted) return;
        context.go('/login');
      } catch (error) {
        if (!context.mounted) return;
        if (error.toString() == 'Not Logged in') context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
        context.go('/');
      }
    });
    return const Scaffold(
      body: SafeArea(
          child: Center(
              child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Logging Out',
          style: TextStyle(fontSize: 24),
        ),
      ))),
    );
  }
}