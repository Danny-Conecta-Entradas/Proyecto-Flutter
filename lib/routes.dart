import 'package:flutter/material.dart' show WidgetBuilder;
import '/routes/home.dart' show Home;
import 'routes/table_registry.dart' show TableRegistry;

final routes = <String, WidgetBuilder>{

  '/': (context) => const Home(),

  '/data-table': (context) => const TableRegistry(),

};
