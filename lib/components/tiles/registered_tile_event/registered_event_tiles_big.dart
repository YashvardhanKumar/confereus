import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../button/filled_button.dart';
import '../../custom_text.dart';

class RegisteredConferenceBigCard extends StatelessWidget {
  const RegisteredConferenceBigCard({
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
      height: 400,
      width: double.infinity,
      child: Material(
        // color: kColorLight,
        // elevation: 10,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: kColorLight,
          highlightColor: kColorLight,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      eventName,
                      fontWeight: FontWeight.w600,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CustomFilledButton(
                        height: 30,
                        onPressed: onRegisterPressed,
                        child: CustomText(
                          (onRegisterPressed != null) ? 'Register' : 'Registered',
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
