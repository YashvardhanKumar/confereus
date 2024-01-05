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
    print(widget.data.toJson());
    return Container(
      margin: const EdgeInsets.all(5.0),
      height: 340,
      width: 200,
      child: Material(
        // color: kColorLight,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        shadowColor: Colors.black12,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: kColorLight,
          highlightColor: kColorLight,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConferencePage(
                  data: widget.data,
                  isRegistered: widget.isRegistered, onRegister: widget.onRegisterPressed,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 180,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),

                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: widget.data.eventLogo != null
                          ? Image.network('${widget.data.eventLogo}', fit: BoxFit.cover,)
                          : const Icon(
                        Icons.image,
                        size: 120,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                CustomText(
                  widget.data.subject,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    // SizedBox(height: 10,),
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
                    if ((widget.data.admin.where((e) => (e.contains(storage.read('userId'))))).isEmpty)
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
