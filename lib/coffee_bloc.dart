import 'package:flutter/cupertino.dart';

double _initialPage = 8.0;

class CoffeeBloc {
  final currentPage = ValueNotifier<double>(_initialPage);
  final textPage = ValueNotifier<double>(_initialPage);

  final pageController = PageController(
    viewportFraction: 0.35,
    initialPage: _initialPage.toInt(),
  );

  final pageTextController = PageController(initialPage: _initialPage.toInt());

  void _coffeeScrollListener() {
    currentPage.value = pageController.page;
  }

  void _textScrollListener() {
    textPage.value = pageController.page;
  }

  void openList() {
    currentPage.value = _initialPage;
    textPage.value = _initialPage;
  }

  void init() {
    pageController.addListener(_coffeeScrollListener);
    pageTextController.addListener(_textScrollListener);
  }

  void dispose() {
    pageController.removeListener(_coffeeScrollListener);
    pageController.dispose();
    pageTextController.removeListener(_textScrollListener);
    pageTextController.dispose();
  }
}

class CoffeeProvider extends InheritedWidget {
  const CoffeeProvider({
    @required this.bloc,
    @required Widget child,
  }) : super(child: child);

  final CoffeeBloc bloc;

  static CoffeeProvider of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CoffeeProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
