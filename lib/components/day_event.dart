import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/conference model/conference.model.dart';
import 'button/add_button.dart';
import 'custom_text.dart';

class DayEvent extends StatefulWidget {
  const DayEvent({
    super.key,
    required this.data,
    required this.date,
    required this.isAdmin,
    required this.conf,
    required this.updateState,
    required this.items,
    required this.addEvent,
  });

  final List<Event> data;
  final Conference conf;
  final DateTime date;
  final bool isAdmin;
  final VoidCallback updateState;
  final List<Widget> items;
  final VoidCallback addEvent;

  @override
  State<DayEvent> createState() => _DayEventState();
}

class _DayEventState extends State<DayEvent>
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
  void didUpdateWidget(DayEvent oldWidget) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomText(
                      DateFormat.yMMMMd().format(widget.date),
                      // fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      expand = !expand;
                      _runExpandCheck();
                      setState(() {});
                    },
                    icon: Icon((expand) ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded),
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
                    const Center(child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CustomText('No Events on this day!'),
                    )),
                  if (widget.isAdmin)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AddButton(
                          text: 'Add Event', onPressed: widget.addEvent),
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
