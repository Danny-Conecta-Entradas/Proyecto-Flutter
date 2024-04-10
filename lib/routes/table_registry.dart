import 'dart:convert' show json;

import 'package:flutter/material.dart' show Axis, BoxDecoration, BuildContext, Colors, Container, CrossAxisAlignment, EdgeInsets, Flex, IntrinsicColumnWidth, SingleChildScrollView, StatefulWidget, StatelessWidget, Table, TableBorder, TableCell, TableCellVerticalAlignment, TableRow, Text;
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class Registry {

  Registry({required this.creation_date, required this.name, required this.dni, required this.birth_date, required this.photo_url});

  final int creation_date;

  final String name;

  final String dni;

  final int birth_date;

  final String? photo_url;

  static fromJSON(dynamic data) {
    return Registry(
      creation_date: data['creation_date'],
      name: data['name'],
      dni: data['dni'],
      birth_date: data['birth_date'],
      photo_url: data['photo_url'],
    );
  }

  static List<Registry> fromJSONArray(dynamic list) {
    final registryList = <Registry>[];

    for (final item in list) {
      final registry = Registry.fromJSON(item);
      registryList.add(registry);
    }

    return registryList;
  }

}

class TableRegistry extends StatefulWidget {

  const TableRegistry({super.key});

  @override
  createState() => _TableRegistryState() as State<TableRegistry>;

}

class _TableRegistryState extends State<TableRegistry> {

  List<Registry>? data;

  void setData(List<Registry>? newValue) {
    setState(() {
      this.data = newValue;
    });
  }

  Future<List<Registry>> getData({String? filter}) async {
    final url = Uri.https(
      'proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app',
      '/api/get-all-data/',
      {'filter': filter},
    );

    final response = await http.get(url);

    final data = Registry.fromJSONArray(json.decode(response.body));

    return data;
  }

  @override
  build(BuildContext context) {
    this.getData().then((value) => setData(value));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Flex(
          direction: Axis.vertical,

          children: [
            Table(
              border: TableBorder.all(color: Colors.black, width: 2),
              defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              // columnWidths: const {
              //   0: IntrinsicColumnWidth(flex: 1),
              //   1: IntrinsicColumnWidth(flex: 1),
              //   2: IntrinsicColumnWidth(flex: 1),
              //   3: IntrinsicColumnWidth(flex: 1),
              //   4: IntrinsicColumnWidth(flex: 1),
              // },

              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                  ),

                  children: [
                    TableCell(
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        child: const Text('Creation Date', softWrap: false,),
                      )
                    ),
                    TableCell(
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(10),
                        child: const Text('Name',),
                      )
                    ),
                    TableCell(
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(10),
                        child: const Text('DNI'),
                      )
                    ),
                    TableCell(
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        child: const Text('Birth Date', softWrap: false,),
                      )
                    ),
                    TableCell(
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(10),
                        child: const Text('Photo'),
                      )
                    ),
                  ],
                ),
                ...?data?.getRange(0, 100).map(
                  (item) => TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),

                    children: [
                      TableCell(child: Container(padding: const EdgeInsets.all(10), color: Colors.amber, width: 40, height: 50, child: Flex(direction: Axis.horizontal, crossAxisAlignment: CrossAxisAlignment.center, children: [Text(DateTime.fromMillisecondsSinceEpoch(item.creation_date).year.toString())],))),
                      TableCell(child: Container(padding: const EdgeInsets.all(10), color: Colors.green, height: 50, child: Text(item.name),)),
                      TableCell(child: Container(padding: const EdgeInsets.all(10), color: Colors.purpleAccent, height: 50, child: Text('12345678A'),)),
                      TableCell(child: Container(padding: const EdgeInsets.all(10), color: Colors.cyanAccent, height: 50, child: Text(item.birth_date.toString()),)),
                      TableCell(child: Container(padding: const EdgeInsets.all(10), color: Colors.indigo, height: 50, child: Text(item.photo_url ?? ''),)),
                    ]
                  ),
                )
              ],
            )
          ],
        )
      )
    );
  }

}
