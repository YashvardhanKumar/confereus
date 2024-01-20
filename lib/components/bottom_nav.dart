import 'package:flutter/material.dart';

import '../constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    required this.items, required this.onChanged, required this.onAddClicked,
  });

  final List<IconData> items;
  final ValueChanged<int> onChanged;
  final VoidCallback onAddClicked;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();

}

class _BottomNavBarState extends State<BottomNavBar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        color: Colors.white,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(widget.items.length + 1, (index) {
          int z = ((widget.items.length) / 2).round();
          if (z == index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                shape: const StadiumBorder(),
                color: kColorDark.withOpacity(0.1),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: widget.onAddClicked,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.5,vertical: 7.5),
                    child: Icon(
                      Icons.add,
                      size: 28,
                      color: kColorDark,
                    ),
                  ),
                ),
              ),
            );
          }
          if ((widget.items.length + 1) / 2 < index) {
            return _CustomBottomBarItem(
              icon: widget.items[index - 1],
              selected: selected == index - 1,
              onTap: () {
                selected = index - 1;
                widget.onChanged(selected);
                setState(() {});
              },
            );
          }
          return _CustomBottomBarItem(
            icon: widget.items[index],
            selected: selected == index,
            onTap: () {
              selected = index;
              widget.onChanged(selected);
              setState(() {});
            },
          );
        }),
      ),
    );
  }
}

class _CustomBottomBarItem extends StatelessWidget {
  const _CustomBottomBarItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(

        borderRadius: BorderRadius.circular(10),
        color: selected ? kColorDark : kColorDark.withOpacity(0.1),
        // padding: EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 7),
            child: Icon(
              icon,
              size: 28,
              color: selected ? Colors.white : kColorDark,
            ),
          ),
        ),
      ),
    );
  }
}