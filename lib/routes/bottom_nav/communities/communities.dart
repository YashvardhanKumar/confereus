import 'package:flutter/material.dart';

import '../../../components/custom_text.dart';
import '../../../constants.dart';
import 'community_topic_list.dart';
import 'create_communities.dart';

class Communities extends StatefulWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Communities'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(
              Icons.groups_rounded,
              size: 45,
              color: kColorDark,
            ),
            title: const CustomText(
              'Create New Community',
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateCommunity(),
                ),
              );
            },
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommunitiesTopicList(),
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "Confereus",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              'A Conference Scheduling app',
                              fontWeight: FontWeight.w600,
                              color: kColorDark,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
