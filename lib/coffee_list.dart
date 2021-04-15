import 'package:coffee_challenge/coffee_bloc.dart';
import 'package:coffee_challenge/coffee_details.dart';
import 'package:coffee_challenge/util.dart';
import 'package:flutter/material.dart';

class CoffeeList extends StatefulWidget {
  @override
  _CoffeeHomeState createState() => _CoffeeHomeState();
}

class _CoffeeHomeState extends State<CoffeeList> {
  final _duration = Duration(milliseconds: 400);
  CoffeeBloc bloc;

  @override
  void initState() {
    bloc = CoffeeProvider.of(context).bloc;
    bloc.openList();
    super.initState();
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
            child: ValueListenableBuilder<double>(
              valueListenable: bloc.currentPage,
              builder: (context, currentPage, _) {
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: bloc.pageController,
                  itemCount: coffees.length + 1,
                  onPageChanged: (value) {
                    if (value < coffees.length) {
                      bloc.pageTextController.animateToPage(
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
                    final result = currentPage - index + 1;
                    final value = -0.4 * result + 1;
                    final opacity = value.clamp(0.0, 1.0);

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 500),
                            pageBuilder: (context, animation, _) {
                              return FadeTransition(
                                opacity: animation,
                                child: CoffeeDetails(coffee: coffee),
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: _CoffeeHeader(),
          ),
        ],
      ),
    );
  }
}

class _CoffeeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = CoffeeProvider.of(context).bloc;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 1.0,
        end: 0.0,
      ),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0.0, -150 * value),
          child: child,
        );
      },
      child: ValueListenableBuilder<double>(
        valueListenable: bloc.textPage,
        builder: (context, textPage, _) {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: coffees.length,
                  controller: bloc.pageTextController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final opacity = (1 - (index - textPage).abs()).clamp(0.0, 1.0);

                    return Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.2,
                        ),
                        child: Hero(
                          tag: 'text_${coffees[index].name}',
                          child: Material(
                            child: Text(
                              coffees[index].name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  _animatedText(textPage.toInt()),
                  style: TextStyle(fontSize: 30),
                  key: _animatedKey(textPage.toInt()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _animatedText(int currentPage) {
    if (currentPage < coffees.length) {
      return '\$${coffees[currentPage].price.toStringAsFixed(2)}';
    }

    return '\$${coffees[currentPage - 1].price.toStringAsFixed(2)}';
  }

  Key _animatedKey(int currentPage) {
    if (currentPage < coffees.length) {
      return Key(coffees[currentPage].name);
    }

    return Key(coffees[currentPage - 1].name);
  }
}
