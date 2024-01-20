import 'package:confereus/common_pages/conference_page.dart';
import 'package:confereus/components/shimmer_widget.dart';
import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/conference model/conference.model.dart';
import '../custom_text.dart';

class RegisteredConferenceCard extends StatelessWidget {
  const RegisteredConferenceCard({
    super.key,
    required this.data,
  });

  final Conference? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: 200,
      width: 200,
      color: Colors.white,
      child: Material(
        // color: kColorLight,
        color: Colors.white,

        elevation: 1,
        shadowColor: Colors.black12,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          splashColor: kColorLight,
          highlightColor: kColorLight,
          onTap: data == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConferencePage(
                        data: data!,
                        isRegistered: true,
                        onRegister: () async {},
                      ),
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: data == null
                              ? ShimmerWidget(height: 120, width: 120,border: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)
                              : data!.eventLogo != null
                                  ? Image.network(
                                    '${data!.eventLogo}',
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                      Icons.image,
                                      size: 120,
                                      color: Colors.grey,
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    (data == null)
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget(height: 15, width: 150),
                              SizedBox(
                                height: 5,
                              ),
                              ShimmerWidget(height: 15, width: 150),
                              SizedBox(height: 5),
                              ShimmerWidget(height: 15, width: 80),
                            ],
                          )
                        : CustomText(
                            data!.subject,
                            fontWeight: FontWeight.w600,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(width: 5),
                    (data == null)
                        ? const ShimmerWidget(height: 12, width: 100)
                        : Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 15,
                                color: Color(0xff8B8B8B),
                              ),
                              const SizedBox(width: 5),
                              CustomText(
                                '${DateFormat.MMMd().format(data!.startTime)} '
                                '-'
                                ' ${DateFormat.yMMMd().format(data!.endTime)}',
                                fontSize: 12,
                                color: const Color(0xff8B8B8B),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                    const SizedBox(height: 5),
                    (data == null)
                        ? const ShimmerWidget(height: 12, width: 100)
                        : const Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 15,
                                color: Color(0xff8B8B8B),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                'Online',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8B8B8B),
                                // fontWeight: FontWeight.w600,
                              ),
                            ],
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
