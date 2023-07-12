import 'package:flutter/material.dart';

import '../../../components/custom_text.dart';
import '../../../constants.dart';

class CommunitiesTopicList extends StatefulWidget {
  const CommunitiesTopicList({Key? key}) : super(key: key);

  @override
  State<CommunitiesTopicList> createState() => _CommunitiesTopicListState();
}

class _CommunitiesTopicListState extends State<CommunitiesTopicList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Yash Community'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            leading: const Icon(
              Icons.add_rounded,
              size: 45,
              color: kColorDark,
            ),
            title: const CustomText(
              'Create New Topic',
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => CreateCommunity(),
              //   ),
              // );
            },
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  tileColor: kColorLight,
                  // clipBehavior: Clip.hardEdge,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: kColorLight,
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: kColorDark,
                    child: Icon(
                      Icons.announcement_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  subtitle: const CustomText(
                    'Lorem ipsum dolor sit amet. Et distinctio hdhhd kekk jajsudh dhdi',
                    fontWeight: FontWeight.w700,
                    color: kColorDark,
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: const CustomText(
                    "Announcement",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  trailing: const Material(
                    shape: CircleBorder(),
                    color: kColorDark,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CustomText(
                        '10',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ListTile(
                  tileColor: kColorLight,
                  // clipBehavior: Clip.hardEdge,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: kColorLight,
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: kColorDark,
                    child: Icon(
                      Icons.topic_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  subtitle: const CustomText(
                    'Lorem ipsum dolor sit amet. Et distinctio hdhhd kekk jajsudh dhdi',
                    fontWeight: FontWeight.w700,
                    color: kColorDark,
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: const CustomText(
                    "General",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  trailing: const Material(
                    shape: CircleBorder(),
                    color: kColorDark,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CustomText(
                        '10',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.white,
                  // clipBehavior: Clip.hardEdge,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: kColorLight,
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: kColorLight,
                    child: Icon(
                      Icons.topic_rounded,
                      color: kColorDark,
                      size: 30,
                    ),
                  ),
                  subtitle: const CustomText(
                    'Lorem ipsum dolor sit amet. Et distinctio hdhhd kekk jajsudh dhdi',
                    fontWeight: FontWeight.w700,
                    color: kColorDark,
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: const CustomText(
                    "Doubts",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),

                  ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.white,
                  // clipBehavior: Clip.hardEdge,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: kColorLight,
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: kColorLight,
                    child: Icon(
                      Icons.topic_rounded,
                      color: kColorDark,
                      size: 30,
                    ),
                  ),
                  subtitle: const CustomText(
                    'Lorem ipsum dolor sit amet. Et distinctio hdhhd kekk jajsudh dhdi',
                    fontWeight: FontWeight.w700,
                    color: kColorDark,
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  title: const CustomText(
                    "Roles",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
