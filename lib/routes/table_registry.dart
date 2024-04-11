import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart' show Axis, BoxDecoration, BuildContext, Colors, EdgeInsets, Image, IntrinsicColumnWidth, MainAxisAlignment, SingleChildScrollView, State, StatefulWidget, Table, TableBorder, TableCell, TableCellVerticalAlignment, TableRow, Text, TextStyle;
import 'dart:math' as Math;

import '/api.dart' show Registry, getData;
import '/utils.dart';
import '/widgets.dart';

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

  void setData(List<Registry>? newValue) {
    setState(() {
      this.data = newValue;
    });
  }

  void setIsLoading(bool newValue) {
    setState(() {
      this.isLoading = newValue;
    });
  }

  Future<void> fetchData({String? filter}) async {
    late final List<Registry> data;

    setIsLoading(true);

    try {
      data = await getData(filter: filter);

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

  Future<void> filterChange(String filterValue, {required BuildContext context}) async {
    await this._fetchTimeout?.cancel();

    this._fetchTimeout = Future<dynamic>
      .delayed(Duration(milliseconds: this._filterDelay))
      .asStream()
      .listen((event) {
        this.fetchData(filter: filterValue);
      });
  }

  @override
  build(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Box(
          verticalGap: 20,

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
                            child: Text('Creation Date'),
                          ),
                        ),
                        TableCell(
                          child: Box(
                            padding: EdgeInsets.all(10),
                            child: Text('Name'),
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
                            child: Text('Birth Date'),
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
                    for (final item in this.data!.getRange(0, Math.min(100, this.data!.length)))
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                        ),

                        children: [
                          TableCell(
                            child: Box(
                              padding: const EdgeInsets.all(10),
                              mainAxisAlignment: MainAxisAlignment.center,

                              child: Text(milisecondsTimeStampToYearMonthDay(item.creation_date)),
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

                              child: Text(milisecondsTimeStampToYearMonthDay(item.birth_date)),
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
                      )
                    ,
                  ],
                )
            ,
          ],
        )
      )
    );
  }

}
