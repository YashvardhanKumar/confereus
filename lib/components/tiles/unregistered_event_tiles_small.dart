import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../models/conference model/conference.model.dart';
import '../button/filled_button.dart';
import '../common_pages/conference_page.dart';
import '../custom_text.dart';

class UnregisteredConferenceCardSmall extends StatelessWidget {
  const UnregisteredConferenceCardSmall({
    super.key,
    required this.onRegisterPressed,
    required this.data,
  });

  final Conference data;

  // final String eventLogo;
  // final String eventName, location, description;
  // final DateTime start, end;
  final VoidCallback? onRegisterPressed;

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
                builder: (_) => ConferencePage(data: data),
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
                          child: data.eventLogo != null ? Image.asset(data.eventLogo!) : const Icon(Icons.image,size: 120,color: Colors.grey,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      data.subject,
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
                    const Row(
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
                          "Online",
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8B8B8B),
                          // fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if(data.admin.toString().compareTo(storage.read('userId')) !=
                        0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CustomFilledButton(
                        height: 30,
                        onPressed: onRegisterPressed,
                        child: const CustomText(
                          'Register',
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