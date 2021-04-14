import 'package:coffee_challenge/coffee_model.dart';
import 'dart:math';

double _doubleInRange(Random source, int start, int end) {
  return source.nextDouble() * (end - start);
}

final _rand = Random();

final coffees = List.generate(
  _names.length,
  (int index) => Coffee(
    name: _names[index],
    image: 'assets/${index + 1}.png',
    price: _doubleInRange(_rand, 2, 8),
  ),
);

final _names = [
  'Caramel Macchiato',
  'Caramel Cold Drink',
  'Iced Coffe Mocha',
  'Caramelized Pecan Latte',
  'Toffee Nut Latte',
  'Capuchino',
  'Toffee Nut Iced Latte',
  'Americano',
  'Vietnamese-Style Iced Coffee',
  'Black Tea Latte',
  'Classic Irish Coffee',
  'Toffee Nut Crunch Latte',
];
