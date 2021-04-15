import 'package:coffee_challenge/util.dart';
import 'package:flutter/material.dart';

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeHomeState createState() => _CoffeeHomeState();
}

double _initialPage = 8.0;

class _CoffeeHomeState extends State<CoffeeList> {
  double _currentPage = _initialPage;
  double _textPage = _initialPage;

  final _pageController = PageController(
    viewportFraction: 0.35,
    initialPage: _initialPage.toInt(),
  );
  final _pageTextController = PageController(initialPage: _initialPage.toInt());

  final _duration = Duration(milliseconds: 400);

  void _coffeeScrollListener() {
    setState(() {
      _currentPage = _pageController.page;
    });
  }

  void _textScrollListener() {
    setState(() {
      _textPage = _currentPage;
    });
  }

  @override
  void initState() {
    _pageController.addListener(_coffeeScrollListener);
    _pageTextController.addListener(_textScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_coffeeScrollListener);
    _pageController.dispose();
    _pageTextController.removeListener(_textScrollListener);
    _pageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 20,
            right: 20,
            bottom: -size.height * 0.2,
            height: size.height * 0.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown,
                    blurRadius: 90,
                    offset: Offset.zero,
                    spreadRadius: 45,
                  ),
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: 1.6,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: coffees.length + 1,
              onPageChanged: (value) {
                if (value < coffees.length) {
                  _pageTextController.animateToPage(
                    value,
                    duration: _duration,
                    curve: Curves.easeOut,
                  );
                }
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox.shrink();
                }

                final coffee = coffees[index - 1];
                final result = _currentPage - index + 1;
                final value = -0.4 * result + 1;
                final opacity = value.clamp(0.0, 1.0);

                return Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..translate(0.0, size.height / 2.6 * (1 - value).abs())
                      ..scale(value),
                    child: Opacity(
                      opacity: opacity,
                      child: Hero(
                        tag: coffee.name,
                        child: Image.asset(
                          coffee.image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: coffees.length,
                    controller: _pageTextController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final opacity = (1 - (index - _textPage).abs()).clamp(0.0, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.2,
                          ),
                          child: Text(
                            coffees[index].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: _duration,
                  child: Text(
                    _animatedText(),
                    style: TextStyle(fontSize: 30),
                    key: _animatedKey(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _animatedText() {
    if (_currentPage.toInt() < coffees.length) {
      return '\$${coffees[_currentPage.toInt()].price.toStringAsFixed(2)}';
    }

    return '\$${coffees[_currentPage.toInt() - 1].price.toStringAsFixed(2)}';
  }

  Key _animatedKey() {
    if (_currentPage.toInt() < coffees.length) {
      return Key(coffees[_currentPage.toInt()].name);
    }
    return Key(coffees[_currentPage.toInt() - 1].name);
  }
}
