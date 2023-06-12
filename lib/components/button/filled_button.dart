import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomFilledButton extends StatefulWidget {
  const CustomFilledButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);
  final double? width, height;
  final Widget child;
  final VoidCallback? onPressed;

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
      color: kColorDark,
      child: InkWell(
        onTap: widget.onPressed!,
        child: Container(
          // margin: const EdgeInsets.all(10),
          height: widget.height ?? 55,
          alignment: Alignment.center,
          width: double.infinity,
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