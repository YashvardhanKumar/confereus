import 'package:confereus/API/user_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/routes/add_about_you_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/button/filled_button.dart';
import '../../components/input_fields/text_form_field.dart';
import '../../models/user model/user_model.dart';

class AddDOBForSSOLogin extends StatefulWidget {
  const AddDOBForSSOLogin({
    Key? key,
  }) : super(key: key);

  @override
  State<AddDOBForSSOLogin> createState() => _AddDOBForSSOLoginState();
}

class _AddDOBForSSOLoginState extends State<AddDOBForSSOLogin> {
  final _formKey = GlobalKey<FormState>();
  final dateCtrl = TextEditingController();
  bool isLoading = false;

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users?>(
        future: Provider.of<UserAPI>(context, listen: false).getCurUsers(),
        builder: (context, snapshot) {
          if (snapshot.data?.dob != null) {
            return const AddAboutYou();
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: const CustomText('Add Date of Birth'),
            ),
            body: FutureBuilder<Users?>(
              future: Provider.of<UserAPI>(context).getCurUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: 'Date of Birth',
                            hint: 'DD/MM/YYYY',
                            controller: dateCtrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date of Birth is Required';
                              }
                              try {
                                final data =
                                DateFormat('dd/MM/yyyy').parseStrict(value);
                                date = date?.copyWith(
                                    hour: data.hour, minute: data.minute);
                              } catch (e) {
                                return 'Invalid Format';
                              }
                              return null;
                            },
                            suffix: GestureDetector(
                              child: const Icon(Icons.calendar_today_rounded),
                              onTap: () async {
                                date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1800),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(date!);
                                  setState(() {
                                    dateCtrl.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            bottomNavigationBar: (snapshot.hasData)
                ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<UserProfileAPI>(
                  builder: (context, userAPI, child) {
                    return CustomFilledButton(
                      isLoading: isLoading,
                      child: const CustomText(
                        'Save',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      onPressed: () async {
                          isLoading = true;

                          if (_formKey.currentState!.validate()) {
                            // if (widget.old != null) {
                            await userAPI
                                .editProfile(context, snapshot.data!, dob: date)
                                .then((value) {
                              isLoading = false;
                              setState(() {});
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AddAboutYou()),
                                  (_) => false);
                            });
                          }
                      },
                    );
                  }),
            )
                : null,
          );
        });
  }
}
