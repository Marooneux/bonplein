import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {

  const AppSearchBar({
    required this.hintText,
    this.controller,
    this.searchSuggestions,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.suggestionsListenable,
    this.suggestionsProvider,
    super.key,
  });

  final String hintText;
  final SearchController? controller;
  final List<String>? searchSuggestions;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<int>? onSuggestionSelected;
  final Listenable? suggestionsListenable;
  final List<String> Function()? suggestionsProvider;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      viewOnChanged: onChanged,
      viewOnSubmitted: onSubmitted,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          hintText: hintText,
          leading: const Icon(Icons.search),
          onTap: controller.openView,
        );
      },
      suggestionsBuilder: (context, controller) {
        return [
          ListenableBuilder(
            listenable: suggestionsListenable!,
            builder: (context, _) {
              final suggestions = suggestionsProvider!();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < suggestions.length; i++)
                    ListTile(
                      title: Text(suggestions[i]),
                      onTap: () {
                        controller.closeView(suggestions[i]);
                        onSuggestionSelected?.call(i);
                      },
                    ),
                ],
              );
            },
          ),
        ];
      },
    );
  }
}
