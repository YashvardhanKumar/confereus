import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDownField extends StatefulWidget {
  final List<String> listItems;
  final String label;
  final String? hint;
  final TextEditingController controller;

  const CustomDropDownField({
    Key? key,
    required this.listItems,
    required this.label,
    this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField>
    with SingleTickerProviderStateMixin {
  late GlobalKey _key;
  bool isMenuOpen = false;
  Offset buttonPosition = Offset.zero;
  Size buttonSize = Size.zero;
  OverlayEntry? _overlayEntry;
  late BorderRadius _borderRadius;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _borderRadius = BorderRadius.circular(5);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry?.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                // title: Text('Select One'),
                children: widget.listItems.map((e) {
                  return SimpleDialogOption(
                    onPressed: () {
                      widget.controller.text = e;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Text(
                          e,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xffD8DADC),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.controller.text.isEmpty
                      ? 'Select One'
                      : widget.controller.text,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: widget.controller.text.isEmpty ? Colors.grey.shade400 : Colors.black,
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );

    //   Container(
    //   key: _key,
    //   decoration: BoxDecoration(
    //     color: Color(0xFFF5C6373),
    //     borderRadius: _borderRadius,
    //   ),
    //   child: IconButton(
    //     icon: AnimatedIcon(
    //       icon: AnimatedIcons.menu_close,
    //       progress: _animationController,
    //     ),
    //     color: Colors.white,
    //     onPressed: () => (isMenuOpen) ? closeMenu() : openMenu(),
    //   ),
    // );
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: widget.listItems.length * buttonSize.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _borderRadius,
                      border: Border.all(
                        color: const Color(0xffD8DADC),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(widget.listItems.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            widget.controller.text = widget.listItems[index];
                            setState(() {});
                            closeMenu();
                          },
                          child: Container(
                            width: buttonSize.width,
                            height: buttonSize.height,
                            child: Text(
                              widget.listItems[index],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
