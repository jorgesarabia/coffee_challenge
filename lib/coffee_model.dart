import 'package:flutter/foundation.dart';

class Coffee {
  Coffee({
    @required this.name,
    @required this.image,
    @required this.price,
  });

  final String name;
  final String image;
  final double price;
}
