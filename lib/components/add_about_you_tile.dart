import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_text.dart';

class AboutTile extends StatefulWidget {
  const AboutTile({
    super.key,
    required this.title,
    required this.items,
    required this.addFunction, this.isAdmin = true,
  });

  final String title;
  final List<Widget> items;
  final VoidCallback addFunction;
  final bool isAdmin;

  @override
  State<AboutTile> createState() => _AboutTileState();
}

class _AboutTileState extends State<AboutTile>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool expand = true;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.ease,
    );
  }

  void _runExpandCheck() {
    if (expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AboutTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.toJson());
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kColorLight,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                expand = !expand;
                _runExpandCheck();
                setState(() {});
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomText(
                        widget.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if(widget.isAdmin)
                  GestureDetector(
                    onTap: widget.addFunction,
                    child: const Icon(Icons.add_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      expand = !expand;
                      _runExpandCheck();
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                  )
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: animation,
            axisAlignment: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.black,
                    height: 0,
                  ),
                  if (widget.items.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.items,
                    ),
                  if (widget.items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomText('No ${widget.title} added'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
