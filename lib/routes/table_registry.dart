import 'dart:async' show StreamSubscription;
import 'dart:convert' show json;

import 'package:flutter/material.dart' show Axis, BoxDecoration, BuildContext, Colors, CrossAxisAlignment, EdgeInsets, Flex, Image, IntrinsicColumnWidth, MainAxisAlignment, SingleChildScrollView, SizedBox, State, StatefulWidget, Table, TableBorder, TableCell, TableCellVerticalAlignment, TableRow, Text, TextStyle;
import 'package:http/http.dart' as http;
import 'dart:math' as Math;

import '/utils.dart';
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

  @override
  initState() {
    super.initState();

    this.fetchData();
  }

  setData(List<Registry>? newValue) {
    setState(() {
      this.data = newValue;
    });
  }

  setIsLoading(bool newValue) {
    setState(() {
      this.isLoading = newValue;
    });
  }

  Future<List<Registry>> getData({String? filter}) async {
    // final url = Uri.https(
    //   'proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app',
    //   '/api/get-all-data/',
    //   {'filter': filter},
    // );

    final url = Uri.http(
      '10.0.2.2:8080',
      '/api/get-all-data/',
      {'filter': filter},
    );

    final http.Response response;

    try {
      response = await http.get(url);
    } catch (reason) {
      print(reason);

      throw Exception('Failed to make request to the server.');
    }

    if (response.statusCode != 200) {
      throw Exception('Request failed with status code ${response.statusCode}.');
    }

    try {
      final data = Registry.fromJSONArray(json.decode(response.body));
      return data;
    } catch (reason) {
      print(reason);

      throw Exception('Failed to parse response.');
    }
  }

  Future fetchData({String? filter}) async {
    late final List<Registry> data;

    setIsLoading(true);

    try {
      data = await this.getData(filter: filter);

      this.setData(data);
    } catch (reason) {
      setData(null);

      final context = this.context;

      if (!context.mounted) {
        return;
      }

      showAlertDialog(
        context: context,
        title: 'title',
        message: reason.toString(),
      );
    }
    finally {
      setIsLoading(false);
    }
  }

  final _filterDelay = 500;

  StreamSubscription<dynamic>? _fetchTimeout;

  var isLoading = false;

  filterChange(String filterValue, {required BuildContext context}) async {
    await this._fetchTimeout?.cancel();

    this._fetchTimeout = Future
      .delayed(Duration(milliseconds: this._filterDelay))
      .asStream()
      .listen((event) {
        this.fetchData(filter: filterValue);
      });
  }

  @override
  build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Box(
              width: 300,

              child: InputTextField(
                label: 'Filter',
                placeholder: 'Filter with Name and DNI',
                style: const TextStyle(color: Colors.white),

                onChange: (filterValue) => this.filterChange(filterValue, context: context),
              ),
            ),
            const SizedBox(height: 20,),
            if (this.isLoading)
              const Box(child: Text('Loading Data...'))
            else
              if (this.data == null)
                const Box(child: Text('Error'),)
              else
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
                    ...this.data!.getRange(0, Math.min(this.data!.length, 100)).map(
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
            ,
          ],
        )
      )
    );
  }

}
