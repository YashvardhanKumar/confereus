import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class TonalOutlinedButton extends StatefulWidget {
  const TonalOutlinedButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);
  final String text;
  final VoidCallback? onPressed;

  @override
  State<TonalOutlinedButton> createState() => _TonalOutlinedButtonState();
}

class _TonalOutlinedButtonState extends State<TonalOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.onPressed != null ? 1 : 0.4,
      child: Material(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: kColorDark),
          borderRadius: BorderRadius.circular(5),
        ),
        color: kColorLight,
        child: InkWell(
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Text(
              widget.text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kColorDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
