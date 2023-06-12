import 'package:flutter/material.dart';

class CustomTextButton extends StatefulWidget {
  const CustomTextButton(
      {Key? key, required this.child, required this.onPressed})
      : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  double opacity = 1;
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 100),
      curve: Curves.bounceInOut,
      onEnd: () {
        opacity = 1;
        setState(() {});
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            opacity = 0.4;
            setState(() {});
            widget.onPressed!();
          }
        },
        child: widget.child,
      ),
    );
  }
}
