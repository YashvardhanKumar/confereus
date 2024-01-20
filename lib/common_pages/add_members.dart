import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:flutter/material.dart';

import '../models/user model/user_model.dart';
import '../components/tiles/search_bar.dart';

class AddMembers extends StatefulWidget {
  const AddMembers(
      {Key? key,
      required this.totalUsers,
      this.selectedUsers,
      this.curUserId,
      this.includeCurUser = false})
      : super(key: key);
  final List<Users> totalUsers;
  final List<Users>? selectedUsers;
  final String? curUserId;
  final bool includeCurUser;

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  late List<Users> selected = widget.selectedUsers ?? [];
  late String query;
  bool searchClicked = false;
  bool nextPage = false;
  late FocusNode focusNode;
  late List<Users> searched;
  late List<Users> totalUsers;

  @override
  void initState() {
    super.initState();
    totalUsers = widget.totalUsers
        .where(
          (element) => widget.includeCurUser || element.id != widget.curUserId,
        )
        .toList();
    searched = totalUsers;
    query = "";
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          selected.isEmpty ? 'Add Members' : '${selected.length} Selected',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextButton(
                child: const CustomText(
                  'Done',
                  color: kColorDark,
                ),
                onPressed: () {
                  Navigator.pop(context, widget.selectedUsers);
                }),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
            child: Row(
              children: [
                Flexible(
                  child: CustomSearchBar(
                    focusNode: focusNode,
                    onChanged: (val) {
                      if (searchClicked == true) {
                        searchClicked = false;
                        focusNode.unfocus();
                      }
                      query = val.toLowerCase();
                      if (query.isNotEmpty) {
                        query = query.toLowerCase().trim();
                        // searchClicked = true;
                        searched = totalUsers.where((e) {
                          String email = e.email;
                          String name = e.name.toLowerCase();
                          return widget.curUserId != e.id &&
                              (email.contains(query) || name.contains(query));
                        }).toList();
                        // focusNode.unfocus();
                      } else {
                        searched = totalUsers;
                      }
                      setState(() {});

                      setState(() {});
                    },
                    onTap: () {
                      if (searchClicked == true) {
                        searchClicked = false;
                        setState(() {});
                      }
                    },
                    onSearchClicked: () {
                      if (query.isNotEmpty) {
                        query = query.toLowerCase().trim();
                        searchClicked = true;
                        searched = totalUsers.where((e) {
                          String email = e.email;
                          String name = e.name.toLowerCase();
                          return widget.curUserId != e.id &&
                              (email.contains(query) || name.contains(query));
                        }).toList();
                        focusNode.unfocus();
                      } else {
                        searched = totalUsers;
                      }
                      setState(() {});
                    },
                    searchClicked: searchClicked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searched.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
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
