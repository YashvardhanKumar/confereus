import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);
  final String text;
  final VoidCallback onPressed;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2, color: kColorDark),
        borderRadius: BorderRadius.circular(5),
      ),
      color: kColorLight,
      child: InkWell(
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 24,
                color: kColorDark,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.text,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kColorDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
