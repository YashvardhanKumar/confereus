import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_text.dart';

Future<Conference> addAbstract(BuildContext context, Conference data) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // useRootNavigator: true,
    builder: (_) {
      return AddAbstractLinkDrawer(data: data);
    },
  );
}

class AddAbstractLinkDrawer extends StatefulWidget {
  const AddAbstractLinkDrawer({
    super.key,
    required this.data,
  });

  final Conference data;

  @override
  State<AddAbstractLinkDrawer> createState() => _AddAbstractLinkDrawerState();
}

class _AddAbstractLinkDrawerState extends State<AddAbstractLinkDrawer> {
  TextEditingController linkCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            // primary: true,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Abstract',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Click on the required google docs file, make a copy and paste the link below.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      // fontWeight: FontWeight.w600,
                      // fontSize: 22,
                      ),
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
                            launchUrl(Uri.parse(abstractUrl));
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
              const SizedBox(
                height: 10,
              ),
              Consumer<ConferenceAPI>(builder: (context, userAPI, child) {
                return CustomFilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final data = await userAPI.editConference(
                        widget.data.id,
                        widget.data,
                        abstractLink: linkCtrl.text,
                      );
                      Navigator.pop(context, data);
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
        );
      },
    );
  }
}
