// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../API/conference_api.dart';
// import '../../API/user_api.dart';
// import '../../main.dart';
// import '../../models/conference model/conference.model.dart';
// import '../custom_text.dart';
// import '../day_event.dart';
//
// class EditEvents extends StatefulWidget {
//   const EditEvents({
//     Key? key,
//     required this.data,
//     required this.isAdmin,
//     required this.events,
//   }) : super(key: key);
//   final Conference data;
//   final bool isAdmin;
//   final List<Event> events;
//
//   @override
//   State<EditEvents> createState() => _AddEventsState();
// }
//
// class _AddEventsState extends State<EditEvents> {
//   @override
//   Widget build(BuildContext context) {
//     // print(widget.data.events?.last.toJson().toString());
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText(
//             (widget.isAdmin)
//                 ? "Edit Events"
//                 : 'Show Events'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           CustomText(
//             '${DateFormat.MMMMd().format(widget.data.startTime)} - ${DateFormat
//                 .yMMMMd().format(widget.data.endTime)}',
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//           ),
//           const SizedBox(
//             height: 35,
//           ),
//           Consumer2<ConferenceAPI, UserAPI>(
//               builder: (context, eventsApi, userApi, child) {
//                 return StreamBuilder<List<Conference>?>(
//                     stream: eventsApi.fetchConference("all").asStream(),
//                     builder: (context, event) {
//                       if (event.hasData) {
//                         final e = widget.data.startTime;
//                         print(e.toIso8601String());
//                         print(event.data?.map((e) => e.toJson()));
//                         return Column(
//                           children: List.generate(
//                             widget.data.endTime.day - widget.data.startTime
//                                 .day + 1,
//                                 (index) {
//                               final dat = event.data!;
//                               //     .where(
//                               //   (v) {
//                               //     return e
//                               //             .copyWith(day: e.day + index)
//                               //             .compareTo(v.startTime) ==
//                               //         0;
//                               //   },
//                               // ).toList();
//                               // print(dat.first.toJson());
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 5.0),
//                                 child: DayEvent(
//                                   data: dat.where((e) => e.id == widget.data.id).first.events!,
//                                   date: e.copyWith(day: e.day + index),
//                                   isAdmin: widget.isAdmin,
//                                   conf: widget.data,
//                                   updateState: () {
//                                     setState(() {});
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     });
//               }),
//         ],
//       ),
//     );
//   }
// }
