import 'package:flutter/material.dart';
import 'package:new_wallpaper_001/screens/search_page.dart';

class SearchBarDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "result");
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/photos.png"),
        height: 200,
        width: 200,
      ),
    );
  }
}
