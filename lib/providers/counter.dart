import 'package:flutter/material.dart';

class CounterState {
  int _value = 0;
   
  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

  bool dif(CounterState old) {
    return old._value == _value;
  }
}

class CounterProvider extends InheritedWidget {
  CounterProvider({
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  final CounterState state = CounterState();

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(CounterProvider oldWidget ) {
    return oldWidget.state.dif(state);
  }
}
