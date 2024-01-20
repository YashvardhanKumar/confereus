import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatefulWidget {
  const CustomOutlinedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.isLoading = false,
  }) : super(key: key);
  final Widget Function(Color color) child;
  final VoidCallback? onPressed;
  final Color? color;
  final double? width, height;
  final bool isLoading;

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  double opacity = 1;
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceInOut,
      onEnd: () {
        opacity = 1;
        setState(() {});
      },
      child: Container(
        height: widget.height ?? 55,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: widget.onPressed == null
                  ? Colors.grey
                  : widget.color ?? kColorDark,
              width: 2),
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: (widget.isLoading)
                ? null
                : () {
                    if (widget.onPressed != null) {
                      opacity = 0.4;
                      setState(() {});
                      widget.onPressed!();
                    }
                  },
            child: (widget.isLoading)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1,
                    ),
                  )
                : widget.child(widget.onPressed == null
                    ? Colors.grey
                    : widget.color ?? kColorDark),
          ),
        ),
      ),
    );
  }
}