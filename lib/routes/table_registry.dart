import 'package:flutter/material.dart' show Axis, BuildContext, Colors, Container, ElevatedButton, Flex, StatelessWidget, Text, TextStyle;

class TableRegistry extends StatelessWidget {

  const TableRegistry({super.key});

  @override
  build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.vertical,

        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 1', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 22', style: TextStyle(color: Colors.black)),
          ),
        ],
      )
    );
  }

}
