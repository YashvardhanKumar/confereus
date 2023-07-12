import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';

import '../../models/user model/user_model.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({Key? key, required this.totalUsers, this.selectedUsers})
      : super(key: key);
  final List<Users> totalUsers;
  final List<Users>? selectedUsers;

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  late List<Users> selected = widget.selectedUsers ?? [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          selected.isEmpty ? 'Add Members' : '${selected.length} Selected',
        ),
        actions: [
          CustomTextButton(
              child: const CustomText(
                'Done',
                color: kColorDark,
              ),
              onPressed: () {
                Navigator.pop(context, widget.selectedUsers);
              })
        ],
      ),
      body: ListView.builder(
        itemCount: widget.totalUsers.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: widget.totalUsers[i].profileImageURL == null
                  ? const Icon(
                      Icons.person_rounded,
                      size: 35,
                    )
                  : Image.network(widget.totalUsers[i].profileImageURL!),
            ),
            title: CustomText(widget.totalUsers[i].name),
            trailing: CustomFilledButton(
              width: 80,
              color:
                  (selected.contains(widget.totalUsers[i])) ? Colors.red : null,
              onPressed: () {
                if (selected.contains(widget.totalUsers[i])) {
                  selected.remove(widget.totalUsers[i]);
                } else {
                  selected.add(widget.totalUsers[i]);
                }
                setState(() {});
              },
              height: 30,
              child: CustomText(
                (selected.contains(widget.totalUsers[i])) ? 'Remove' : 'Add',
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
