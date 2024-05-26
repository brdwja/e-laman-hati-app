import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _NavigationDestination {
    const _NavigationDestination({required this.label, required this.icon, required this.selectedIcon, required this.route});

    static const _NavigationDestination separator = _NavigationDestination(
      label: Text(''),
      icon: Icon(Icons.abc),
      selectedIcon: Icon(Icons.abc),
      route: '',
    );

    final Widget label;
    final Widget icon;
    final Widget selectedIcon;
    final String route;
  }

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static final List<_NavigationDestination> _navigationDrawerDestinations = <_NavigationDestination>[
    const _NavigationDestination(
      label: Text('Home'),
      icon: Icon(Icons.home_outlined, color: Color(0xff172b4d)),
      selectedIcon: Icon(Icons.home, color: Color(0xff172b4d)),
      route: '/'
    ),
    _NavigationDestination.separator,
    const _NavigationDestination(
      label: Text('Minta Bantuan'),
      icon: Icon(Icons.calendar_month_outlined, color: Color(0xff172b4d)),
      selectedIcon: Icon(Icons.calendar_month, color: Color(0xff172b4d)),
      route: '/requestbantuan'
    ),
    const _NavigationDestination(
      label: Text('Hewan Peliharaan'),
      icon: Icon(Icons.pets_outlined, color: Color(0xff172b4d)),
      selectedIcon: Icon(Icons.pets, color: Color(0xff172b4d)),
      route: '/hewanpeliharaan'
    ),
    _NavigationDestination.separator,
     _NavigationDestination(
      label: const Text('Cek Data DinaHate', style: TextStyle(
        color: Colors.cyan,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),),
      icon: Image.asset('assets/images/dinahate-darkblue.png', height: 32,),
      selectedIcon: Image.asset('assets/images/dinahate-darkblue.png', height: 32,),
      route: '/dinahate'
    ),
    _NavigationDestination.separator,
    const _NavigationDestination(
      label: Text('Keluar'),
      icon: Icon(Icons.rocket_launch_outlined),
      selectedIcon: Icon(Icons.rocket_launch),
      route: '/logout'
    ),
  ];

  
  @override
  Widget build(BuildContext context) {
    String currentRoute = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    List<_NavigationDestination> destinations = _navigationDrawerDestinations.where((element) => !identical(element, _NavigationDestination.separator)).toList();
    int routeIndex = 0;
    for (_NavigationDestination navItem in destinations) {
      if (navItem.route == currentRoute) {
        break;
      }
      routeIndex++;
    }
    return NavigationDrawer(
        onDestinationSelected: (int screen) {
          Navigator.pop(context);
          context.go(destinations[screen].route);
        },
        selectedIndex: routeIndex,
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32), child: Image.asset('assets/images/lamanhati-pink.png', width: 200,),),
          
          ..._navigationDrawerDestinations.map(
            (_NavigationDestination destination) {
            if (identical(destination, _NavigationDestination.separator)) {
              return const Divider(thickness: 1,indent: 25, endIndent: 20,);
            }
            return NavigationDrawerDestination(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                label: destination.label);
            }
          ),

          const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 16, 28), child: Divider()),
        ],
      );
  } 
}