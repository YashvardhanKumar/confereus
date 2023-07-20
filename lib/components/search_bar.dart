import 'package:flutter/material.dart';
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key,
    required this.onSearchClicked,
    required this.onChanged,
    required this.onTap,
    this.focusNode,
    required this.searchClicked, this.filterIcon,});

  final VoidCallback onSearchClicked;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final bool searchClicked;
  final Widget? filterIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      // shape: searchClicked ? StadiumBorder() : null,
      clipBehavior: Clip.hardEdge,
      child: AnimatedContainer(
        curve: Curves.easeInOutCubicEmphasized,
        margin: EdgeInsets.symmetric(horizontal: searchClicked ? 16 : 0),
        decoration: BoxDecoration(
          color: const Color(0xffefe9f5),
          borderRadius:
          BorderRadius.circular(searchClicked ? kToolbarHeight : 0),
        ),
        height: ((searchClicked) ? kToolbarHeight - 8 : kToolbarHeight + 24),
        width: double.infinity,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 400),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  focusNode: focusNode,
                  onTap: onTap,
                  textInputAction: TextInputAction.search,
                  onEditingComplete: onSearchClicked,
                  onChanged: onChanged,
                  autofocus: true,
                  cursorColor: const Color(0xff49454F),
                  decoration: const InputDecoration(border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(fontFamily: 'Poppins')),
                ),
              ),
            ),
            IconButton(
              onPressed: onSearchClicked,
              icon: const Icon(
                Icons.search_rounded,
                color: Color(0xff49454F),
              ),
            ),
            if(filterIcon != null)
              filterIcon!,
          ],
        ),
      ),
    );
  }
}