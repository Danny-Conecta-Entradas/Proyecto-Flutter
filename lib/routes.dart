import 'package:flutter/material.dart' show WidgetBuilder, Text, TextStyle, Container, Colors, ElevatedButton, Flex, Axis;
import './routes/home.dart' show Home;

final routes = <String, WidgetBuilder>{

  '/': (context) => const Home(title: 'App Title'),

  '/sonic': (context) => Container(color: Colors.amber, child:Flex(
    direction: Axis.vertical,

    children: [
      ElevatedButton(
        onPressed: () {},
        child: const Text('Button 1', style: TextStyle(color: Colors.black)),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Button 2', style: TextStyle(color: Colors.black)),
      ),
    ],
  )),

};
