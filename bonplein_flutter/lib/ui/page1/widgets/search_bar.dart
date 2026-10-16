import 'dart:async';
import 'package:bonplein_flutter/ui/page1/view_models/page1_view_model.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.viewModel,
    required this.hintText,
    super.key,
  });

  final Page1ViewModel viewModel;
  final String hintText;
  static const radius12 = Radius.circular(12);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSuggestionTap(AddressSuggestion suggestion) {
    _controller.text = suggestion.label;
    FocusManager.instance.primaryFocus?.unfocus();
    unawaited(widget.viewModel.selectSuggestion(suggestion));
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(SearchBarWidget.radius12),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: widget.viewModel.searchAddress,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            //style: AppTypography.preset9,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.hintText,
              //hintStyle: AppTypography.preset9,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
          ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              final suggestions = widget.viewModel.suggestions;
              if (suggestions.isEmpty) return const SizedBox.shrink();
              return Card(
                margin: const EdgeInsets.only(top: 4),
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined),
                      title: Text(suggestion.label),
                      onTap: () => _onSuggestionTap(suggestion),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
