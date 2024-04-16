import 'package:flutter/material.dart';

import '../../commons/commons.dart';

mixin DependencyMixin<T extends StatefulWidget> on State<T> {
  // Método para acessar o container de dependências
  DependencyContainer get dependencies {
    return DependencyProvider.of(context);
  }
}
