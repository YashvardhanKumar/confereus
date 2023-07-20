import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/conference model/conference.model.dart';
import '../button/filled_button.dart';
import '../common_pages/conference_page.dart';
import '../custom_text.dart';

class ConferenceBigCard extends StatefulWidget {
  const ConferenceBigCard({
    super.key,
    required this.onRegisterPressed, required this.data, required this.isRegistered,
  });
  final Conference data;

  final bool isRegistered;
  final Future<void> Function() onRegisterPressed;

  @override
  State<ConferenceBigCard> createState() => _ConferenceBigCardState();
}

class _ConferenceBigCardState extends State<ConferenceBigCard> {

  bool isClicked = false;

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      widget.data.subject,
                      fontWeight: FontWeight.w600,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                      height: 10,
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
