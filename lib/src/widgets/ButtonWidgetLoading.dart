import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum LoadingState { idle, loading, success, error }

class ButtonWidgetLoad extends StatefulWidget {
  final ButtonWidgetLoadController controller;
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double height;
  final double width;
  final double loaderSize;
  final double loaderStrokeWidth;
  final bool animateOnTap;
  final Color valueColor;
  final Curve curve;
  final double borderRadius;
  final Duration duration;
  final double elevation;
  final Color errorColor;
  final Color successColor;
  final Color disabledColor;

  Duration get _borderDuration {
    return new Duration(
        milliseconds: (this.duration.inMilliseconds / 2).round());
  }

  ButtonWidgetLoad(
      {Key key,
        this.controller,
        this.onPressed,
        this.child,
        this.color,
        this.height = 50,
        this.width = 300,
        this.loaderSize = 24.0,
        this.loaderStrokeWidth = 2.0,
        this.animateOnTap = true,
        this.valueColor = Colors.white,
        this.borderRadius = 35,
        this.elevation = 2,
        this.duration = const Duration(milliseconds: 500),
        this.curve = Curves.easeInOutCirc,
        this.errorColor = Colors.red,
        this.successColor,
        this.disabledColor});

  @override
  State<StatefulWidget> createState() => ButtonWidgetLoadState();
}

class ButtonWidgetLoadState extends State<ButtonWidgetLoad>
    with TickerProviderStateMixin {
  AnimationController _buttonController;
  AnimationController _borderController;
  AnimationController _checkButtonControler;

  Animation _squeezeAnimation;
  Animation _bounceAnimation;
  Animation _borderAnimation;

  final _state = BehaviorSubject<LoadingState>.seeded(LoadingState.idle);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    var _check = Container(
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: widget.successColor ?? theme.primaryColor,
          borderRadius:
          new BorderRadius.all(Radius.circular(_bounceAnimation.value / 2)),
        ),
        width: _bounceAnimation.value,
        height: _bounceAnimation.value,
        child: _bounceAnimation.value > 20
            ? Icon(
          Icons.check,
          color: widget.valueColor,
        )
            : null);

    var _cross = Container(
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: widget.errorColor,
          borderRadius:
          new BorderRadius.all(Radius.circular(_bounceAnimation.value / 2)),
        ),
        width: _bounceAnimation.value,
        height: _bounceAnimation.value,
        child: _bounceAnimation.value > 20
            ? Icon(
          Icons.close,
          color: widget.valueColor,
        )
            : null);

    var _loader = SizedBox(
        height: widget.loaderSize,
        width: widget.loaderSize,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
            strokeWidth: widget.loaderStrokeWidth));

    var childStream = StreamBuilder(
      stream: _state,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child:
            snapshot.data == LoadingState.loading ? _loader : widget.child);
      },
    );

    var _btn = ButtonTheme(
        shape: RoundedRectangleBorder(borderRadius: _borderAnimation.value),
        minWidth: _squeezeAnimation.value,
        height: widget.height,
        child: RaisedButton(
            padding: EdgeInsets.all(0),
            child: childStream,
            color: widget.color,
            disabledColor: widget.disabledColor,
            elevation: widget.elevation,
            onPressed: widget.onPressed == null ? null : _btnPressed));

    return Container(
        height: widget.height,
        child: Center(
            child: _state.value == LoadingState.error
                ? _cross
                : _state.value == LoadingState.success
                ? _check
                : _btn));
  }

  @override
  void initState() {
    super.initState();

    _buttonController =
    new AnimationController(duration: widget.duration, vsync: this);

    _checkButtonControler = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    _borderController =
    new AnimationController(duration: widget._borderDuration, vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: widget.height).animate(
        new CurvedAnimation(
            parent: _checkButtonControler, curve: Curves.elasticOut));
    _bounceAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation = Tween<double>(begin: widget.width, end: widget.height)
        .animate(new CurvedAnimation(
        parent: _buttonController, curve: widget.curve));

    _squeezeAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation.addStatusListener((state) {
      if (state == AnimationStatus.completed && widget.animateOnTap) {
        widget.onPressed();
      }
    });

    _borderAnimation = BorderRadiusTween(
        begin: BorderRadius.circular(widget.borderRadius),
        end: BorderRadius.circular(widget.height))
        .animate(_borderController);

    _borderAnimation.addListener(() {
      setState(() {});
    });

    widget.controller?._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _checkButtonControler.dispose();
    _borderController.dispose();
    super.dispose();
  }

  void disposeState() {
    _state.close();
  }

  _btnPressed() async {
    if (widget.animateOnTap) {
      _start();
    } else {
      widget.onPressed();
    }
  }

  _start() {
    _state.sink.add(LoadingState.loading);
    _borderController.forward();
    _buttonController.forward();
  }

  _stop() {
    _state.sink.add(LoadingState.idle);
    _buttonController.reverse();
    _borderController.reverse();
  }

  _success() {
    _state.sink.add(LoadingState.success);
    _checkButtonControler.forward();
  }

  _error() {
    _state.sink.add(LoadingState.error);
    _checkButtonControler.forward();
  }

  _reset() {
    _state.sink.add(LoadingState.idle);
    _buttonController.reverse();
    _borderController.reverse();
    _checkButtonControler.reset();
  }
}

class ButtonWidgetLoadController {
  VoidCallback _startListener;
  VoidCallback _stopListener;
  VoidCallback _successListener;
  VoidCallback _errorListener;
  VoidCallback _resetListener;

  _addListeners(
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      VoidCallback errorListener,
      VoidCallback resetListener) {
    this._startListener = startListener;
    this._stopListener = stopListener;
    this._successListener = successListener;
    this._errorListener = errorListener;
    this._resetListener = resetListener;
  }

  start() {
    _startListener();
  }

  stop() {
    _stopListener();
  }

  success() {
    _successListener();
  }

  error() {
    _errorListener();
  }

  reset() {
    _resetListener();
  }
}