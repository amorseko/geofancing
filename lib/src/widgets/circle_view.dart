import 'package:flutter/material.dart';

class CircleView extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;
  final double borderSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            width: size,
            height: size,
            decoration: new BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                    color: borderColor ?? Colors.transparent,
                    width: borderSize ?? 0.0)),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0,
          child: child,
        ),
      ],
    );
  }

  CircleView(
      {this.size, this.color, this.child, this.borderColor, this.borderSize});
}