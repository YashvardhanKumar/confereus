import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomFilledButton extends StatefulWidget {
  const CustomFilledButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height, this.color,
  }) : super(key: key);
  final double? width, height;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  double opacity = 1;
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        // side: BorderSide(width: 2, color: kColorDark),
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      color: (widget.onPressed != null) ? (widget.color ?? kColorDark) : kColorDark.withOpacity(0.3),
      child: InkWell(
        splashColor: kColorLight.withOpacity(0.7),
        highlightColor: kColorLight.withOpacity(0.7),
        onTap: widget.onPressed,
        child: Container(
          // margin: const EdgeInsets.all(10),
          height: widget.height ?? 55,
          alignment: Alignment.center,
          width: widget.width ?? double.infinity,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(5),
          //   color: widget.onPressed == null
          //       ? Colors.grey
          //       : kColorDark,
          // ),
          child: widget.child,
        ),
      ),
    );
  }
}