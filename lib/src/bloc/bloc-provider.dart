import 'package:flutter/material.dart';

class BlocProvider<T> extends InheritedWidget {
  final T _bloc;

  const BlocProvider({
    Key key,
    @required T bloc,
    @required Widget child,
  })  : _bloc = bloc,
        super(key: key, child: child);

  static T of<T>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    final BlocProvider<T> provider = context.inheritFromWidgetOfExactType(type);
    if (provider == null) throw StateError('Inherited Provider does not exist');
    return provider._bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(_) => true;
}