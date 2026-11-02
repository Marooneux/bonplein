import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final SearchController? controller;
  final List<String>? searchSuggestions;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<int>? onSuggestionSelected;

  const AppSearchBar({
    required this.hintText,
    this.controller,
    this.searchSuggestions,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          hintText: hintText,
          leading: const Icon(Icons.search),
          onTap: controller.openView,
          onChanged: (text) {
            controller.openView();
            onChanged?.call(text);
          },
          onSubmitted: onSubmitted,
        );
      },
      suggestionsBuilder: (context, controller) {
        return [
          for (var i = 0; i < searchSuggestions!.length; i++)
            ListTile(
              title: Text(searchSuggestions![i]),
              onTap: () {
                controller.closeView(searchSuggestions?[i]);
                onSuggestionSelected?.call(i);
              }
            ),
        ];
      },
    );
  }
}
