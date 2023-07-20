import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../models/conference model/conference.model.dart';
import '../button/filled_button.dart';
import '../common_pages/conference_page.dart';
import '../custom_text.dart';

class UnregisteredConferenceCardSmall extends StatefulWidget {
  const UnregisteredConferenceCardSmall({
    super.key,
    required this.onRegisterPressed,
    required this.data,
    required this.isRegistered,
  });

  final Conference data;
  final bool isRegistered;

  // final String eventLogo;
  // final String eventName, location, description;
  // final DateTime start, end;
  final Future<void> Function() onRegisterPressed;

  @override
  State<UnregisteredConferenceCardSmall> createState() =>
      _UnregisteredConferenceCardSmallState();
}

class _UnregisteredConferenceCardSmallState
    extends State<UnregisteredConferenceCardSmall> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: 340,
      width: 200,
      child: Material(
        // color: kColorLight,
        elevation: 1,
        shadowColor: Colors.black12,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          splashColor: kColorLight,
          highlightColor: kColorLight,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConferencePage(
                  data: widget.data,
                  isRegistered: widget.isRegistered,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Material(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: widget.data.eventLogo != null
                              ? Image.network('$url/${widget.data.eventLogo}', fit: BoxFit.cover,)
                              : const Icon(
                                  Icons.image,
                                  size: 120,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      widget.data.subject,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 15,
                          color: Color(0xff8B8B8B),
                        ),
                        const SizedBox(width: 5),
                        CustomText(
                          '${DateFormat.MMMd().format(widget.data.startTime)} '
                          '-'
                          ' ${DateFormat.yMMMd().format(widget.data.endTime)}',
                          fontSize: 12,
                          color: const Color(0xff8B8B8B),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    if(widget.data.location != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 15,
                          color: Color(0xff8B8B8B),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          widget.data.location!,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8B8B8B),
                          // fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.data.admin
                            .toString()
                            .compareTo(storage.read('userId')) !=
                        0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CustomFilledButton(
                          height: 30,
                          onPressed: widget.isRegistered || isClicked
                              ? null
                              : () async {
                                  isClicked = true;
                                  setState(() {});
                                  await widget
                                      .onRegisterPressed()
                                      .then((value) {
                                    isClicked = false;
                                    setState(() {});
                                  });
                                },
                          child: CustomText(
                            widget.isRegistered ? 'Registered' : 'Register',
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
