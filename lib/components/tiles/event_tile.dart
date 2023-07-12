import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../API/user_api.dart';
import '../../models/conference model/conference.model.dart';
import '../bottom_drawers/edit_event.dart';
import '../button/text_button.dart';
import '../custom_text.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.isAdmin,
    required this.data,
  });

  final Event event;
  final bool isAdmin;
  final Conference data;

  // final String eventName, location;
  // final String? presenter;
  // final DateTime start, end;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: CustomText(
                DateFormat.Hm().format(event.startTime),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalDivider(
              color: Colors.black,
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    event.subject,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  if (event.presenter != null && event.presenter!.isEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  if (event.presenter != null && event.presenter!.isEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.present_to_all_rounded,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          event.presenter!.join(", "),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          // fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: Color(0xff8B8B8B),
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        '${DateFormat.Hm().format(event.startTime)} '
                            '-'
                            ' ${DateFormat.Hm().format(event.endTime)}',
                        fontSize: 12,
                        color: const Color(0xff8B8B8B),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
                        event.location,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff8B8B8B),
                        // fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAdmin)
              Column(
                children: [
                  CustomTextButton(
                    onPressed: () {
                      Provider.of<UserAPI>(context, listen: false)
                          .getAllUsers(context)
                          .then(
                            (value) => editEvents(
                          context,
                          data,
                          event.startTime,
                          event,
                          value ?? [],
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.edit_rounded),
                    ),
                  ),
                  CustomTextButton(
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.delete_forever_rounded),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
