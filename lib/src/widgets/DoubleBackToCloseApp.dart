import 'dart:io';

import 'package:flutter/material.dart';

/// Allows the user to close the app by double tapping the back-button.
///
/// You must specify a [SnackBar], so it can be shown when the user taps the
/// back-button. Notice that the value you set for [SnackBar.duration] is going
/// to be considered to decide whether the snack-bar is currently visible or
/// not.
///
/// Since the back-button is an Android feature, this Widget is going to be
/// nothing but the own [child] if the current platform is anything but Android.
class DoubleBackToCloseApp extends StatefulWidget {
  final SnackBar snackBar;
  final Widget child;

  const DoubleBackToCloseApp({
    Key key,
    @required this.snackBar,
    @required this.child,
  })  : assert(snackBar != null),
        assert(child != null),
        super(key: key);

  @override
  DoubleBackToCloseAppState createState() => DoubleBackToCloseAppState();
}

@visibleForTesting
class DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  /// The last time the user tapped Android's back-button.
  DateTime lastTimeBackButtonWasTapped;

  /// Returns whether the current platform is Android.
  bool get isAndroid => Theme.of(context).platform == TargetPlatform.android;

  /// Returns whether the [DoubleBackToCloseApp.snackBar] is currently visible.
  ///
  /// The snack-bar is going to be considered visible if the duration of the
  /// snack-bar is greater than the difference from now to the
  /// [lastTimeBackButtonWasTapped].
  ///
  /// This is not quite accurate since the snack-bar could've been dismissed by
  /// the user, so this algorithm needs to be improved, as described in #2.
  bool get isSnackBarVisible =>
      (lastTimeBackButtonWasTapped != null) &&
          (widget.snackBar.duration >
              DateTime.now().difference(lastTimeBackButtonWasTapped));

  /// Returns whether the next back navigation of this route will be handled
  /// internally.
  ///
  /// Returns true when there's a widget that inserted an entry into the
  /// local-history of the current route, in order to handle pop. This is done
  /// by [Drawer], for example, so it can close on pop.
  bool get willHandlePopInternally =>
      ModalRoute.of(context).willHandlePopInternally;

  @override
  Widget build(BuildContext context) {
    ensureThatContextContainsScaffold();

    if (isAndroid) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  /// Handles [WillPopScope.onWillPop].
  Future<bool> onWillPop() async {
    if (isSnackBarVisible || willHandlePopInternally) {
//      return true;
      exit(0);
      return true;
    } else {
      lastTimeBackButtonWasTapped = DateTime.now();
      Scaffold.of(context).showSnackBar(widget.snackBar);
      return false;
    }
  }

  /// Throws a [StateError] if this widget was not wrapped in a [Scaffold].
  void ensureThatContextContainsScaffold() {
    if (Scaffold.of(context) == null) {
      throw StateError(
        '`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.',
      );
    }
  }
}