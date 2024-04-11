import 'package:flutter/material.dart' show AppBar, BoxDecoration, BuildContext, Color, Colors, DefaultTextStyle, Drawer, DrawerHeader, EdgeInsets, GlobalKey, Icon, Icons, ListTile, ListView, MaterialApp, MaterialPageRoute, Navigator, NavigatorState, Scaffold, ScaffoldState, StatelessWidget, Text, TextStyle, ThemeData, Widget, runApp;
import 'package:loader_overlay/loader_overlay.dart' show LoaderOverlay;
import '/routes.dart' show routes;
import '/widgets.dart' show Box;


/// Handle nested navigation
final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<ScaffoldState>();

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {

  const AppRoot({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(),

      home: Scaffold(
        key: scaffoldKey,

        appBar: AppBar(
          title: const Text('Flutter App'),
          backgroundColor: const Color.fromARGB(255, 48, 102, 181),
          foregroundColor: Colors.white,
        ),

        drawer: const NavigationDrawer(),

        body: LoaderOverlay(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),

            // child: FractionallySizedBox(
            //   widthFactor: 1.0,
            //   heightFactor: 1.0,

            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     color: const Color.fromARGB(255, 5, 69, 109),

            //     child: Flex(direction: Axis.vertical, children: [Expanded(child: AppNavigation(routes: routes))],),
            //   ),
            // ),
            child: Box(
              widthFactor: 1.0,
              heightFactor: 1.0,

              padding: const EdgeInsets.all(10),
              backgroundColor: const Color.fromARGB(255, 5, 69, 109),

              expandChild: true,

              child: AppNavigation(routes: routes),
            ),
          ),
        ),
      ),
    );
  }

}


class AppNavigation extends StatelessWidget {

  const AppNavigation({super.key, required this.routes});

  final Map<String, Widget Function(BuildContext)> routes;

  @override
  build(BuildContext context) {
    return Navigator(
      key: navigatorKey,

      initialRoute: '/',

      onGenerateRoute: (settings) {
        final builder = this.routes[settings.name];

        if (builder == null) {
          throw Exception('Invalid route: ${settings.name}');
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

}


class NavigationDrawer extends StatelessWidget {

  const NavigationDrawer({super.key});

  @override
  build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 6, 140, 155),

      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 36, 85, 95)),
            child: Text(
              'Navigation Panel',
              style: TextStyle(color: Colors.white, fontSize: 24,),
            )
          ),
          ListTile(
            title: const Text('Home', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.home, color: Colors.white,),
            onTap: () {
              navigatorKey.currentState?.pushNamed('/');

              scaffoldKey.currentState?.closeDrawer();
            },
          ),
          ListTile(
            title: const Text('View Registry', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.table_chart, color: Colors.white,),
            onTap: () {
              navigatorKey.currentState?.pushNamed('/data-table');

              scaffoldKey.currentState?.closeDrawer();
            },
          ),
        ],
      ),
    );
  }

}
