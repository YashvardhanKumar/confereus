import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'custom_text.dart';

class CurrentConferenceCard extends StatelessWidget {
  const CurrentConferenceCard({Key? key, required this.data}) : super(key: key);
  final Conference data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        elevation: 0,
        color: kColorDark.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: data.eventLogo != null
                          ? Image.asset(
                              data.eventLogo!,
                              height: 100,
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_rounded,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            data.subject,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 18,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: Color(0xff8B8B8B),
                              ),
                              const SizedBox(width: 5),
                              CustomText(
                                '${DateFormat.MMMd().format(data.startTime)} '
                                '-'
                                ' ${DateFormat.yMMMd().format(data.endTime)}',
                                fontSize: 12,
                                color: const Color(0xff8B8B8B),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          if (data.location != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: Color(0xff8B8B8B),
                                ),
                                SizedBox(width: 5),
                                CustomText(
                                  data.location!,
                                  fontSize: 10,
                                  color: Color(0xff8B8B8B),
                                ),
                              ],
                            ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black)),
                                  child: const Row(
                                    children: [
                                      CustomText(
                                        'Join link',
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (data.events!.isNotEmpty)
                const SizedBox(height: 5),

              if (data.events!.isNotEmpty)
                Container(
                  // avatar: Icon(Icons.event_rounded),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  // labelPadding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              data.events![0].subject,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            CustomText(
                              (data.events![0].startTime
                                          .compareTo(DateTime.now().toUtc()) <=
                                      0)
                                  ? 'Ends at ${DateFormat.jm().format(data.events![0].endTime)}'
                                  : 'Starts at ${DateFormat.jm().format(data.events![0].startTime)}',
                              fontSize: 10,
                              color: const Color(0xff8B8B8B),
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      if (data.events![0].startTime
                              .compareTo(DateTime.now().toUtc()) <=
                          0)
                        CustomText(
                          'Ongoing',
                          fontSize: 12,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
