import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:flutter/material.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({Key? key}) : super(key: key);

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final commNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      // margin: EdgeInsets.all(10),
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        size: 96,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(
                      Icons.add_circle_rounded,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                const Flexible(
                  child: CustomText(
                    'Add Community Logo',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              label: 'Community name',
              controller: commNameCtrl,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              label: 'Brief Description',
              controller: commNameCtrl,
              maxLines: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            AddButton(
              text: 'Add Members',
              onPressed: () {},
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomFilledButton(
          child: const CustomText(
            'Create',
            color: Colors.white,
            fontSize: 20,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
