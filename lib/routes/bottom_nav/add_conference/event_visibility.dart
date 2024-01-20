import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';

class EventVisibility extends StatefulWidget {
  const EventVisibility({Key? key, required this.data}) : super(key: key);
  final Conference data;

  @override
  State<EventVisibility> createState() => _EventVisibilityState();
}

class _EventVisibilityState extends State<EventVisibility> {
  bool isPrivateEvent = false;
  bool allowSpam = false;
  String? selectedCommunity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text('Event Visibility'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                isPrivateEvent = !isPrivateEvent;
                setState(() {});
              },
              child: Row(
                children: [
                  Checkbox(
                    value: isPrivateEvent,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) {
                      isPrivateEvent = !isPrivateEvent;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const CustomText(
                    'Private Event',
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // GestureDetector(
            //   onTap: () {
            //     allowSpam = !allowSpam;
            //     setState(() {});
            //   },
            //   child: Row(
            //     children: [
            //       Checkbox(
            //         value: allowSpam,
            //         visualDensity: VisualDensity.compact,
            //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //         onChanged: isPrivateEvent
            //             ? (val) {
            //                 allowSpam = !allowSpam;
            //                 setState(() {});
            //               }
            //             : null,
            //       ),
            //       const SizedBox(
            //         width: 5,
            //       ),
            //       GestureDetector(
            //         onTap: isPrivateEvent
            //             ? () {
            //                 allowSpam = !allowSpam;
            //                 setState(() {});
            //               }
            //             : null,
            //         child: const CustomText(
            //           'Allow Spam/ Reported Attendees',
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
            // if (selectedCommunity != null)
            //   const CustomText(
            //     'Community Added',
            //     fontSize: 18,
            //     fontWeight: FontWeight.w600,
            //   ),
            // if (selectedCommunity != null) const SizedBox(height: 10),
            // if (selectedCommunity != null)
            //   Material(
            //     color: kColorLight,
            //     clipBehavior: Clip.hardEdge,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     child: InkWell(
            //       onTap: () {},
            //       child: SizedBox(
            //         width: double.infinity,
            //         child: Padding(
            //           padding: const EdgeInsets.all(10.0),
            //           child: Row(
            //             children: [
            //               CircleAvatar(
            //                 radius: 25,
            //                 backgroundColor: Colors.white,
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(5.0),
            //                   child: Image.asset('images/logo.png'),
            //                 ),
            //               ),
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //               const Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   CustomText(
            //                     "Confereus",
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 16,
            //                   ),
            //                   SizedBox(height: 5),
            //                   CustomText(
            //                     'A Conference Scheduling app',
            //                     fontWeight: FontWeight.w600,
            //                     color: kColorDark,
            //                   )
            //                 ],
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // if (selectedCommunity != null)
            //   const SizedBox(
            //     height: 20,
            //   ),
            // TonalOutlinedButton(
            //   text: 'Choose Community',
            //   onPressed: isPrivateEvent
            //       ? () async {
            //           selectedCommunity = await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (_) => const SelectCommunity(),
            //             ),
            //           );
            //           setState(() {});
            //         }
            //       : null,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomFilledButton(
          child: const CustomText(
            'Create Event',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          onPressed: () {
            Provider.of<ConferenceAPI>(context,listen: false).editConference(widget.data.id, widget.data, visibility: isPrivateEvent ? "Private": "Public");
            while(Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
