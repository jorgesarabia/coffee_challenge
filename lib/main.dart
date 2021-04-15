import 'package:coffee_challenge/coffee_bloc.dart';
import 'package:flutter/material.dart';

import 'coffee_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bloc = CoffeeBloc();

  @override
  void initState() {
    bloc.init();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CoffeeProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CoffeeHome(),
      ),
    );
  }
}
