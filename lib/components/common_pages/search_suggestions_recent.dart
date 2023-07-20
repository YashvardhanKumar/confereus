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
      children: const [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: CustomText(
            'Recent Search',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        RecentSearchListTile(
          query: '3D Character',
        ),
        RecentSearchListTile(
          query: 'CryptoPunks',
        ),
        RecentSearchListTile(
          query: 'Anime',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
        RecentSearchListTile(
          query: 'Cartoon',
        ),
      ],
    );
  }
}
