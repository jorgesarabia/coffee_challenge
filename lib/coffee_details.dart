import 'package:coffee_challenge/coffee_model.dart';
import 'package:flutter/material.dart';

class CoffeeDetails extends StatelessWidget {
  const CoffeeDetails({@required this.coffee});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.2,
            ),
            child: Hero(
              tag: 'text_${coffee.name}',
              child: Material(
                child: Text(
                  coffee.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            height: size.height * 0.4,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: coffee.name,
                    child: Image.asset(coffee.image),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
