import 'package:confereus/components/common_pages/search_page.dart';
import 'package:flutter/material.dart';
import '../custom_text.dart';
class SearchBarButton extends StatelessWidget {
  const SearchBarButton({
    super.key,
    required this.hintText,
    required this.isNFTResults,
  });

  final String hintText;
  final bool isNFTResults;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          //TODO: NFT Search Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchUser(
                isNFTResults: isNFTResults,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffefe9f5),
            borderRadius: BorderRadius.circular(50),
          ),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomText(
                      hintText,
                      color: const Color(0xff49454F),
                      fontSize: 14,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xff49454F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}