import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';

class CreateNewConference extends StatefulWidget {
  const CreateNewConference({Key? key}) : super(key: key);

  @override
  State<CreateNewConference> createState() => _CreateNewConferenceState();
}

class _CreateNewConferenceState extends State<CreateNewConference> {
  final subjectCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final startTimeCtrl = TextEditingController();
  final endTimeCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CustomTextFormField(label: 'Subject of Conference', controller: subjectCtrl),
            SizedBox(height: 10,),
            CustomTextFormField(label: 'About the Conference', controller: aboutCtrl, minLines: 5,),
            SizedBox(height: 10,),
            Row(
              children: [
                Flexible(child: CustomTextFormField(label: 'Start Date', controller: startDateCtrl)),
                SizedBox(width: 10,),
                Flexible(child: CustomTextFormField(label: 'Start Time', controller: startTimeCtrl)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Flexible(child: CustomTextFormField(label: 'End Date', controller: startDateCtrl)),
                SizedBox(width: 10,),
                Flexible(child: CustomTextFormField(label: 'End Time', controller: startTimeCtrl)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
