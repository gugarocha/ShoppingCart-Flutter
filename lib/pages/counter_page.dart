import 'package:flutter/material.dart';

import '../providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context)?.state.dec();
              });
            },
            icon: const Icon(Icons.remove),
          ),
          Text('${CounterProvider.of(context)?.state.value ?? '0'}'),
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context)?.state.inc();
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
