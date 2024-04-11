import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './views/homepage/homepage.dart';
import './views/intro/intro.dart';
import './views/login/login.dart';
import './views/register/register.dart';
import './views/requestbantuan/requestbantuan.dart';
import './views/hewanpeliharaan/hewanpeliharaan.dart';
import './views/statistik/statistik.dart';
import './views/logout/logout.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Homepage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'intro',
          builder: (BuildContext context, GoRouterState state) {
            return const Intropage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const Loginpage();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const Registerpage();
          },
        ),
        GoRoute(
          path: 'requestbantuan',
          builder: (BuildContext context, GoRouterState state) {
            return const RequestBantuan();
          },
        ),
        GoRoute(
          path: 'hewanpeliharaan',
          builder: (BuildContext context, GoRouterState state) {
            return const HewanPeliharaan();
          },
        ),
        GoRoute(
          path: 'statistik',
          builder: (BuildContext context, GoRouterState state) {
            return const Statistikpage();
          },
        ),
        GoRoute(
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            return const Logoutpage();
          },
        ),
        
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'e-Laman Hati',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffea4c89)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
