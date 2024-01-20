import 'package:confereus/API/abstract_api.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/abstract model/abstract.model.dart';
import '../components/button/filled_button.dart';

class ShowAbstract extends StatefulWidget {
  const ShowAbstract({Key? key, required this.isAdmin, required this.abstract})
      : super(key: key);
  final bool isAdmin;
  final Abstract abstract;

  @override
  State<ShowAbstract> createState() => _ShowAbstractState();
}

class _ShowAbstractState extends State<ShowAbstract> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomText(
                    'Paper Title',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(widget.abstract.paperName),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: CustomText(
                          'Abstract',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await launchUrl(Uri.parse(widget.abstract.paperLink));
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.open_in_new_rounded),
                            SizedBox(
                              width: 3,
                            ),
                            CustomText('Open Link')
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomText(widget.abstract.abstract),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomText(
                    'Published at',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                      DateFormat.yMMMMd().format(widget.abstract.createdAt))
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CustomText(
                    'Approved',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  if (widget.abstract.isApproved)
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                            "Approved on ${DateFormat.yMMMMd().format(widget.abstract.approved!)}"),
                      ],
                    ),
                  if (!widget.abstract.isApproved &&
                      widget.abstract.approved == null)
                    const Row(
                      children: [
                        Icon(
                          Icons.timelapse,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText("Yet to approve"),
                      ],
                    ),
                  if (!widget.abstract.isApproved &&
                      widget.abstract.approved != null)
                    const Row(
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText("Your Paper is rejected"),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (widget.isAdmin && widget.abstract.approved == null)
          ? Consumer<AbstractAPI>(builder: (context, abstractAPI, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomFilledButton(
                        color: kColorDark,
                        onPressed: isClicked
                            ? null
                            : () async {
                                // if (!widget) {
                                isClicked = true;
                                setState(() {});
                                await abstractAPI.approveAbstract(
                                    widget.abstract.conferenceId,
                                    widget.abstract,
                                    widget.abstract.id,
                                    approved: DateTime.now().toUtc(),
                                    isApproved: true);
                                Navigator.pop(context);
                                //TODO: Add Approval
                              },
                        child: const CustomText(
                          'Approve',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomFilledButton(
                        color: kColorLight,
                        onPressed: isClicked
                            ? null
                            : () async {
                                // if (!widget) {
                                isClicked = true;
                                setState(() {});
                                await abstractAPI.approveAbstract(
                                    widget.abstract.conferenceId,
                                    widget.abstract,
                                    widget.abstract.id,
                                    approved: DateTime.now().toUtc(),
                                    isApproved: false);

                                Navigator.pop(context);
                                //TODO: Add Approval
                              },
                        child: const CustomText(
                          'Reject',
                          color: kColorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
          : null,
    );
  }
}
