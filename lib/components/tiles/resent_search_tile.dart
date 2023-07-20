import 'package:flutter/material.dart';
import '../custom_text.dart';
class RecentSearchListTile extends StatelessWidget {
  const RecentSearchListTile({
    super.key,
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: () {},
      leading: const Icon(
        Icons.access_time_rounded,
        color: Color(0xff595757),
      ),
      title: CustomText(
        query,
        color: const Color(0xff595757),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.close_rounded,
          color: Color(0xff595757),
        ),
      ),
    );
  }
}