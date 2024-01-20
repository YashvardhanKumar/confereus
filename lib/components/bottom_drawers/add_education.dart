import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<Education?> addEducation(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    // useRootNavigator: true,
    builder: (_) {
      return const AddEducation();
    },
  );
}

class AddEducation extends StatefulWidget {
  const AddEducation({
    super.key,
  });

  @override
  State<AddEducation> createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  TextEditingController instituteCtrl = TextEditingController();
  TextEditingController degreeCtrl = TextEditingController();
  TextEditingController fieldCtrl = TextEditingController();
  TextEditingController workLocCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  DateTime? start, end;
  bool studyingHere = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: kThemeAnimationDuration,
      child: BottomSheet(
        onClosing: () {},
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Education',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Institute/School/University name',
                    controller: instituteCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                    hint: 'Eg. Amity University',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Degree',
                    controller: degreeCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                    hint: 'Eg. BTech',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Field',
                    controller: fieldCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                    hint: 'Eg. Information Technology',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Location (optional)',
                    controller: workLocCtrl,
                    hint: 'Eg. Bandra, India',
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: CustomTextFormField(
                          label: 'Start',
                          controller: startDateCtrl,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Field Required";
                            }
                            try {
                              start = DateFormat('MM/yyyy').parseStrict(val);
                              setState(() {});
                            } catch (e) {
                              return "Invalid Format";
                            }
                            return null;
                          },
                          hint: 'MM/YYYY',
                          suffix: GestureDetector(
                            child: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              start = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1800),
                                lastDate: DateTime.now(),
                              );
                              if (start != null) {
                                String formattedDate =
                                    DateFormat('MM/yyyy').format(start!);
                                setState(() {
                                  startDateCtrl.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: CustomTextFormField(
                          enabled: !studyingHere,
                          label: 'End',
                          controller: endDateCtrl,
                          validator: (studyingHere)
                              ? null
                              : (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Field Required";
                                  }
                                  try {
                                    end = DateFormat('MM/yyyy').parseStrict(val);
                                    setState(() {});
                                  } catch (e) {
                                    return "Invalid Format";
                                  }
                                  return null;
                                },
                          hint: 'MM/YYYY',
                          suffix: GestureDetector(
                            child: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              end = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1800),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 20, hours: 6 * 20)),
                              );
                              if (end != null) {
                                String formattedDate =
                                    DateFormat('MM/yyyy').format(end!);
                                setState(() {
                                  endDateCtrl.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    studyingHere = !studyingHere;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: studyingHere,
                        onChanged: (val) {
                          studyingHere = val!;
                          setState(() {});
                        },
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text(
                        'Currently studying here',
                        style: GoogleFonts.poppins(),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<UserProfileAPI>(
                      builder: (context, userAPI, child) {
                    return CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Education education = Education(
                              id: "",
                              institution: instituteCtrl.text,
                              degree: degreeCtrl.text,
                              field: fieldCtrl.text,
                              start: start!,
                              end: end);
                          final data =
                              await userAPI.addEducation(context, education);
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
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
