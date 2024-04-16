import 'package:flutter/material.dart';

import 'dependency_container.dart';

class DependencyProvider extends InheritedWidget {
  final DependencyContainer container;

  const DependencyProvider({
    Key? key,
    required this.container,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) {
    return container != oldWidget.container;
  }

  static DependencyContainer of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DependencyProvider>();
    if (provider == null) {
      throw Exception('DependencyContainer not found in context');
    }
    return provider.container;
  }
}