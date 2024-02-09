import 'package:flutter/material.dart';

class BolusNotifier extends InheritedWidget {
  final Function(double) updateLastBolus;

  BolusNotifier({
    Key? key,
    required Widget child,
    required this.updateLastBolus,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static BolusNotifier? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BolusNotifier>();
  }
}
