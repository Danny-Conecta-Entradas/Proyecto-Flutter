import 'package:flutter/material.dart' show
  runApp, StatelessWidget, BuildContext, MaterialApp, ThemeData, Scaffold,
  AppBar, Text, Colors, Color, DefaultTextStyle, TextStyle
;
import 'package:loader_overlay/loader_overlay.dart' show LoaderOverlay;
import 'package:proyecto_flutter_daniel/routes/home.dart' show Home;


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
        appBar: AppBar(
          title: const Text('Flutter App'),
          backgroundColor: const Color.fromARGB(255, 48, 102, 181),
          foregroundColor: Colors.white,
        ),

        body: const LoaderOverlay(
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: Home(title: 'App Title'),
          )
        )
      ),
    );
  }

}
