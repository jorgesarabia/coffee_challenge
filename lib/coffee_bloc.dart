import 'package:flutter/cupertino.dart';

class CoffeeBloc {}

class CoffeeProvider extends InheritedWidget {
  const CoffeeProvider({
    @required this.bloc,
    @required Widget child,
  }) : super(child: child);

  final CoffeeBloc bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
