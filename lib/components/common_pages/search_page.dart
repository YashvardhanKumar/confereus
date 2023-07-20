import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../search_bar.dart';
import 'search_suggestions_recent.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    this.appendInQuery = '',
    required this.isNFTResults,
  }) : super(key: key);
  final String appendInQuery;
  final bool isNFTResults;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String query;
  bool searchClicked = false;
  bool nextPage = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    query = widget.appendInQuery;
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor:
          searchClicked ? Colors.transparent : const Color(0xffefe9f5),
        ),
        title: Row(
          children: [
            Flexible(
              child: CustomSearchBar(
                focusNode: focusNode,
                onChanged: (val) {
                  if (searchClicked == true) {
                    searchClicked = false;
                    focusNode.unfocus();
                  }
                  query = val;
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
                    searchClicked = true;
                    focusNode.unfocus();
                    setState(() {});
                  }
                },
                searchClicked: searchClicked,
              ),
            ),
          ],
        ),
      ),
      body: SearchSuggestions(query: query,),
    );
  }
}
