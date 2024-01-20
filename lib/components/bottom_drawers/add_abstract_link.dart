import 'package:confereus/API/abstract_api.dart';
import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/models/abstract%20model/abstract.model.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../API/user_api.dart';
import '../../models/user model/user_model.dart';
import '../button/add_button.dart';
import '../../common_pages/add_members.dart';
import '../custom_text.dart';

// Future<Conference> addAbstract(BuildContext context, Conference data) async {
//   // return await showModalBottomSheet(
//   //   context: context,
//   //   isScrollControlled: true,
//   //   // useRootNavigator: true,
//   //   builder: (_) {
//       return AddAbstractLinkDrawer(data: data);
//     // },
//   // );
// }

class AddAbstractLinkDrawer extends StatefulWidget {
  const AddAbstractLinkDrawer({
    super.key,
    required this.data,
    required this.curUser,
    required this.dataEvent,
  });

  final Conference data;
  final Event dataEvent;
  final Users curUser;

  @override
  State<AddAbstractLinkDrawer> createState() => _AddAbstractLinkDrawerState();
}

class _AddAbstractLinkDrawerState extends State<AddAbstractLinkDrawer> {
  TextEditingController linkCtrl = TextEditingController();
  TextEditingController abstractCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();
  String? link;
  late List<Users> selected = [widget.curUser];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const CustomText('Add Abstract'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          // primary: true,
          // mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'Add Abstract',
            //     textAlign: TextAlign.center,
            //     style: GoogleFonts.poppins(
            //       fontWeight: FontWeight.w600,
            //       fontSize: 22,
            //     ),
            //   ),
            // ),
            Text(
              'Click on the required google docs file, make a copy, Edit the paper, and paste the link below.',
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                  // fontWeight: FontWeight.w600,
                  // fontSize: 22,
                  ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: fetch(abstractUrl),
                    builder: (context, snapshot) {
                      // if (!snapshot.hasData) {
                      //   return Container();
                      // }
                      return InputChip(
                        label: CustomText(
                          snapshot.data?['title'].split('.').first ??
                              'loading...',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse(abstractUrl),
                              mode: LaunchMode.platformDefault);
                        },
                        avatar: const Icon(Icons.text_snippet_rounded),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: fetch(fullPaperUrl),
                    builder: (context, snapshot) {
                      // if (!snapshot.hasData) {
                      //   return Container();
                      // }
                      return InputChip(
                        onPressed: () {
                          launchUrl(Uri.parse(fullPaperUrl));
                        },
                        label: CustomText(
                          snapshot.data?['title'].split('.').first ??
                              'loading...',
                          overflow: TextOverflow.ellipsis,
                        ),
                        avatar: const Icon(Icons.text_snippet_rounded),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomTextFormField(
                label: 'Paper Title',
                controller: titleCtrl,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomTextFormField(
                maxLines: 6,
                label: 'Abstract',
                controller: abstractCtrl,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                hint: "Write a brief abstract about your paper",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomTextFormField(
                onChanged: (val) {
                  link = val;
                  setState(() {});
                },
                suffix: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FutureBuilder<Map<String, dynamic>?>(
                      future: fetch(linkCtrl.text),
                      builder: (context, snapshot) {
                        return CustomTextButton(
                            onPressed:
                                snapshot.hasData && linkCtrl.text.isNotEmpty
                                    ? () {
                                        titleCtrl.text = snapshot.data?['title']
                                            .split('.')
                                            .first;
                                        setState(() {});
                                      }
                                    : null,
                            child: const CustomText(
                              'Generate Title',
                              fontWeight: FontWeight.w600,
                            ));
                      }),
                ),
                label: 'Attach Link',
                controller: linkCtrl,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                hint: 'https://www.docs.google.com/....',
              ),
            ),
            Row(
              children: List.generate(
                selected.length,
                (index) => InputChip(label: Text(selected[index].name)),
              ),
            ),
            FutureBuilder<List<Users>?>(
                future: Provider.of<UserAPI>(context).getAllUsers(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AddButton(
                      onPressed: () async {
                        selected = await Navigator.push<List<Users>>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddMembers(
                                  totalUsers: snapshot.data!,
                                  selectedUsers: selected,
                                  curUserId: widget.curUser.id,
                                ),
                              ),
                            ) ??
                            selected;
                        setState(() {});
                      },
                      text: 'Add Paper Contributors',
                    );
                  }
                  return Container();
                }),
            const SizedBox(
              height: 10,
            ),
            Consumer<AbstractAPI>(builder: (context, absAPI, child) {
              return CustomFilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final data_ = Abstract(
                      eventId: widget.dataEvent.id,
                      paperName: titleCtrl.text,
                      paperLink: linkCtrl.text,
                      id: "",
                      conferenceId: widget.data.id,
                      userId: selected.map((e) => e.id).toList(),
                      abstract: abstractCtrl.text,
                      createdAt: DateTime.now().toUtc(),
                    );
                    final data = await absAPI.addAbstract(
                      widget.data.id,
                      data_,
                      // abstractLink: linkCtrl.text,
                    );
                    Navigator.pop(context,data);
                  }
                },
                child: Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
