import 'dart:convert' show json;

import 'package:flutter/material.dart' show Axis, BoxDecoration, BuildContext, Colors, EdgeInsets, Flex, Image, IntrinsicColumnWidth, MainAxisAlignment, SingleChildScrollView, State, StatefulWidget, Table, TableBorder, TableCell, TableCellVerticalAlignment, TableRow, Text;
import 'package:http/http.dart' as http;

import '../utils.dart';
import '/widgets.dart';

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
                const TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),

                  children: [
                    TableCell(
                      child: Box(
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                        child: Text('Creation Date', softWrap: false,),
                      ),
                    ),
                    TableCell(
                      child: Box(
                        padding: EdgeInsets.all(10),
                        child: Text('Name',),
                      )
                    ),
                    TableCell(
                      child: Box(
                        padding: EdgeInsets.all(10),
                        child: Text('DNI'),
                      )
                    ),
                    TableCell(
                      child: Box(
                        padding: EdgeInsets.all(10),
                        child: Text('Birth Date', softWrap: false,),
                      )
                    ),
                    TableCell(
                      child: Box(
                        padding: EdgeInsets.all(10),
                        child: Text('Photo'),
                      )
                    ),
                  ],
                ),
                ...?data?.getRange(0, 100).map(
                  (item) {
                    final creation_date = milisecondsTimeStampToYearMonthDay(item.creation_date);
                    final birth_date = milisecondsTimeStampToYearMonthDay(item.birth_date);

                    return TableRow(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                      ),

                      children: [
                        TableCell(
                          child: Box(
                            padding: const EdgeInsets.all(10),
                            mainAxisAlignment: MainAxisAlignment.center,

                            child: Text(creation_date),
                          )
                        ),
                        TableCell(
                          child: Box(
                            padding: const EdgeInsets.all(10),
                            mainAxisAlignment: MainAxisAlignment.center,

                            child: Text(item.name),
                          )
                        ),
                        TableCell(
                          child: Box(
                            padding: const EdgeInsets.all(10),
                            mainAxisAlignment: MainAxisAlignment.center,

                            child: Text(item.dni),
                          )
                        ),
                        TableCell(
                          child: Box(
                            padding: const EdgeInsets.all(10),
                            mainAxisAlignment: MainAxisAlignment.center,

                            child: Text(birth_date),
                          )
                        ),
                        TableCell(
                          child: Box(
                            padding: const EdgeInsets.all(10),
                            mainAxisAlignment: MainAxisAlignment.center,

                            child: (item.photo_url != null && item.photo_url != '') ? Image.network(item.photo_url!, width: 50, height: 50,) : null
                          )
                        ),
                      ]
                    );
                  }
                )
              ],
            )
          ],
        )
      )
    );
  }

}
