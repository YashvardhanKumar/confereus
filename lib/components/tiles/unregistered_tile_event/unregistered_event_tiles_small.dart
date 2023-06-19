import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../button/filled_button.dart';
import '../../custom_text.dart';

class UnregisteredConferenceCardSmall extends StatelessWidget {
  const UnregisteredConferenceCardSmall({
    super.key,
    required this.eventLogo,
    required this.eventName,
    required this.location,
    required this.start,
    required this.end,
    required this.onRegisterPressed,
  });

  final String eventLogo;
  final String eventName, location;
  final DateTime start, end;
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
          onTap: () {},
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
                          child: Image.asset(eventLogo),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      eventName,
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
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 15,
                          color: Color(0xff8B8B8B),
                        ),
                        SizedBox(width: 5),
                        CustomText(
                          '${DateFormat.MMMd().format(start)} '
                          '-'
                          ' ${DateFormat.yMMMd().format(end)}',
                          fontSize: 12,
                          color: Color(0xff8B8B8B),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
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
                          location,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8B8B8B),
                          // fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CustomFilledButton(
                        height: 30,
                        child: CustomText(
                          'Register',
                          color: Colors.white,
                        ),
                        onPressed: onRegisterPressed,
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
