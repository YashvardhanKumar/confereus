import 'package:flutter/material.dart';
import '../custom_text.dart';
import '../tiles/resent_search_tile.dart';

class SearchSuggestions extends StatefulWidget {
  const SearchSuggestions({
    super.key, required this.query,
  });
  final String query;

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  int? chipCustomSelected;


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: CustomText(
            'Recent Search',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const RecentSearchListTile(
          query: '3D Character',
        ),
        const RecentSearchListTile(
          query: 'CryptoPunks',
        ),
        const RecentSearchListTile(
          query: 'Anime',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
        const RecentSearchListTile(
          query: 'Cartoon',
        ),
      ],
    );
  }
}
